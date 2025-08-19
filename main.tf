# Creating network and subnet
resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

# Creating 2 identical virtual machines using count
resource "yandex_compute_instance" "vm" {
  count       = 2
  name        = "vm-${count.index}"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu image ID (replace if needed)
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true # Enable public IP
  }

  metadata = {
    user-data = file("./cloud-init.yml")
    ssh-keys  = "ubuntu:${file("./key.pub")}"
  }
}

# Creating target group for load balancer
resource "yandex_lb_target_group" "my_target_group" {
  name = "my-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.vm
    content {
      subnet_id = yandex_vpc_subnet.subnet.id
      address   = target.value.network_interface.0.ip_address
    }
  }
}

# Creating HTTP load balancer
resource "yandex_lb_network_load_balancer" "load_balancer" {
  name = "load-balancer"

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.my_target_group.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

# Creating Ansible inventory file
resource "local_file" "ansible_inventory" {
  file_permission = "0644"
  filename        = "./hosts.ini"
  content         = <<EOT
[all]
%{for host in yandex_compute_instance.vm~}
${trimspace("${host.name} ansible_host=${host.network_interface.0.nat_ip_address}")}
%{endfor~}
EOT
}
