source "vmware-iso" "alpine-3-14" {
  boot_command = [
    "root<enter><wait>",
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/answers<enter><wait>",
    "setup-apkrepos -1<enter><wait5>",
    "ERASE_DISKS='/dev/sda' setup-alpine -f $PWD/answers<enter><wait5>",
    "${var.ssh_password}<enter><wait>",
    "${var.ssh_password}<enter><wait30>",
    "mount /dev/sda3 /mnt<enter>",
    "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config<enter>",
    "umount /mnt ; reboot<enter>"
  ]
  cpus                 = "${var.vm_cpu_num}"
  disk_additional_size = ["${var.vm_disk_additional_size}"]
  disk_size            = "${var.vm_disk_size}"
  disk_type_id         = "thin"
  guest_os_type        = "other5xlinux-64"
  http_directory       = "http"
  insecure_connection  = true
  iso_checksum         = "sha256:d568c6c71bb1eee0f65cdf40088daf57032e24f1e3bd2cf8a813f80d2e9e4eab"
  iso_url              = "http://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-virt-3.14.0-x86_64.iso"
  keep_registered      = true
  memory               = "${var.vm_mem_size}"
  network_adapter_type = "vmxnet3"
  network_name         = "${var.network_name}"
  remote_datastore     = "${var.remote_datastore}"
  remote_host          = "${var.esxi_host}"
  remote_password      = "${local.esxi_password}"
  remote_port          = 22
  remote_type          = "esx5"
  remote_username      = "${local.esxi_username}"
  shutdown_command     = "/sbin/poweroff"
  skip_export          = true
  ssh_password         = "${var.ssh_password}"
  ssh_username         = "root"
  vm_name              = "${local.vm_name}"
  vmx_data = {
    "virtualhw.version" = "19"
  }
  vnc_over_websocket = "true"
}

build {
  sources = ["source.vmware-iso.alpine-3-14"]

  provisioner "breakpoint" {
    disable = true
    note    = "If mirroring the data volume, this is when you would go add the third disk and reboot before continuing. (Check Readme for details)"
  }

  provisioner "shell" {
    inline = [
      "echo http://dl-cdn.alpinelinux.org/alpine/v3.14/community >> /etc/apk/repositories",
      "apk update",
      "apk add sudo",
      "apk add open-vm-tools",
      "rc-update add open-vm-tools boot",
      "echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/wheel",
      "user=${var.ssh_username}",
      "echo Add user $user with NOPASSWD sudo",
      "adduser $user --disabled-password",
      "echo '${var.ssh_username}:${var.ssh_password}' | chpasswd",
      "adduser $user wheel",
    ]
  }
}
