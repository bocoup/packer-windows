locals {
  autounattend = templatefile("./answer_files/10/Autounattend.xml", {})
}

variable "disk_size" {
  type    = string
  default = "61440"
}

variable "disk_type_id" {
  type    = string
  default = "1"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:69efac1df9ec8066341d8c9b62297ddece0e6b805533fdb6dd66bc8034fba27a"
}

variable "iso_url" {
  type    = string
  default = "https://software-download.microsoft.com/download/sg/444969d5-f34g-4e03-ac9d-1f9786c69161/19044.1288.211006-0501.21h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "restart_timeout" {
  type    = string
  default = "5m"
}

variable "vhv_enable" {
  type    = string
  default = "false"
}

variable "virtio_win_iso" {
  type    = string
  default = "~/virtio-win.iso"
}

variable "vm_name" {
  type    = string
  default = "windows_10"
}

variable "vmx_version" {
  type    = string
  default = "14"
}

variable "winrm_timeout" {
  type    = string
  default = "6h"
}

source "hyperv-iso" "windows_10" {
  boot_wait             = "6m"
  communicator          = "winrm"
  configuration_version = "8.0"
  cpus                  = "2"
  disk_size             = "${var.disk_size}"
  floppy_files          = [
    "./floppy/WindowsPowershell.lnk",
    "./floppy/PinTo10.exe",
    "./scripts/fixnetwork.ps1",
    "./scripts/disable-screensaver.ps1",
    "./scripts/disable-winrm.ps1",
    "./scripts/enable-winrm.ps1",
    "./scripts/microsoft-updates.bat",
    "./scripts/win-updates.ps1"
  ]
  floppy_content       = {
    "Autounattend.xml" = var.autounattend
  }
  guest_additions_mode  = "none"
  iso_checksum          = "${var.iso_checksum}"
  iso_url               = "${var.iso_url}"
  memory                = "${var.memory}"
  shutdown_command      = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  vm_name               = "${var.vm_name}"
  winrm_password        = "vagrant"
  winrm_timeout         = "${var.winrm_timeout}"
  winrm_username        = "vagrant"
}

source "parallels-iso" "windows_10" {
  boot_command           = [""]
  boot_wait              = "6m"
  communicator           = "winrm"
  cpus                   = 2
  disk_size              = "${var.disk_size}"
  floppy_files           = [
    "./floppy/WindowsPowershell.lnk",
    "./floppy/PinTo10.exe",
    "./scripts/fixnetwork.ps1",
    "./scripts/disable-screensaver.ps1",
    "./scripts/disable-winrm.ps1",
    "./scripts/enable-winrm.ps1",
    "./scripts/microsoft-updates.bat",
    "./scripts/win-updates.ps1"
  ]
  floppy_content       = {
    "Autounattend.xml" = var.autounattend
  }
  guest_os_type          = "win-10"
  iso_checksum           = "${var.iso_checksum}"
  iso_url                = "${var.iso_url}"
  memory                 = "${var.memory}"
  parallels_tools_flavor = "win"
  parallels_tools_mode   = "disable"
  prlctl                 = [
    ["set", "{{ .Name }}", "--adaptive-hypervisor", "on"],
    ["set", "{{ .Name }}", "--efi-boot", "off"]
  ]
  shutdown_command       = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  vm_name                = "${var.vm_name}"
  winrm_password         = "vagrant"
  winrm_timeout          = "${var.winrm_timeout}"
  winrm_username         = "vagrant"
}

source "qemu" "windows_10" {
  accelerator      = "kvm"
  boot_wait        = "6m"
  communicator     = "winrm"
  cpus             = "2"
  disk_size        = "${var.disk_size}"
  floppy_files     = [
    "./floppy/WindowsPowershell.lnk",
    "./floppy/PinTo10.exe",
    "./scripts/fixnetwork.ps1",
    "./scripts/disable-screensaver.ps1",
    "./scripts/disable-winrm.ps1",
    "./scripts/enable-winrm.ps1",
    "./scripts/microsoft-updates.bat",
    "./scripts/win-updates.ps1"
  ]
  floppy_content       = {
    "Autounattend.xml" = var.autounattend
  }
  headless         = true
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  memory           = "${var.memory}"
  output_directory = "windows_10-qemu"
  qemuargs         = [
    ["-drive", "file=windows_10-qemu/{{ .Name }},if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1"],
    ["-drive", "file=${var.iso_url},media=cdrom,index=2"],
    ["-drive", "file=${var.virtio_win_iso},media=cdrom,index=3"]
  ]
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  vm_name          = "${var.vm_name}"
  winrm_password   = "vagrant"
  winrm_timeout    = "${var.winrm_timeout}"
  winrm_username   = "vagrant"
}

source "virtualbox-iso" "windows_10" {
  boot_command         = [""]
  boot_wait            = "6m"
  communicator         = "winrm"
  cpus                 = 2
  disk_size            = "${var.disk_size}"
  floppy_files         = [
    "./floppy/WindowsPowershell.lnk",
    "./floppy/PinTo10.exe",
    "./scripts/fixnetwork.ps1",
    "./scripts/disable-screensaver.ps1",
    "./scripts/disable-winrm.ps1",
    "./scripts/enable-winrm.ps1",
    "./scripts/microsoft-updates.bat",
    "./scripts/win-updates.ps1"
  ]
  floppy_content       = {
    "Autounattend.xml" = var.autounattend
  }
  guest_additions_mode = "disable"
  guest_os_type        = "Windows10_64"
  headless             = "${var.headless}"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = "${var.memory}"
  shutdown_command     = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  vm_name              = "${var.vm_name}"
  winrm_password       = "vagrant"
  winrm_timeout        = "${var.winrm_timeout}"
  winrm_username       = "vagrant"
}

source "vmware-iso" "windows_10" {
  boot_command      = [""]
  boot_wait         = "6m"
  communicator      = "winrm"
  cpus              = 2
  disk_adapter_type = "lsisas1068"
  disk_size         = "${var.disk_size}"
  disk_type_id      = "${var.disk_type_id}"
  floppy_files      = [
    "./floppy/WindowsPowershell.lnk",
    "./floppy/PinTo10.exe",
    "./scripts/fixnetwork.ps1",
    "./scripts/disable-screensaver.ps1",
    "./scripts/disable-winrm.ps1",
    "./scripts/enable-winrm.ps1",
    "./scripts/microsoft-updates.bat",
    "./scripts/win-updates.ps1"
  ]
  floppy_content       = {
    "Autounattend.xml" = var.autounattend
  }
  guest_os_type     = "windows9-64"
  headless          = "${var.headless}"
  iso_checksum      = "${var.iso_checksum}"
  iso_url           = "${var.iso_url}"
  memory            = "${var.memory}"
  shutdown_command  = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  version           = "${var.vmx_version}"
  vm_name           = "${var.vm_name}"
  vmx_data = {
    "RemoteDisplay.vnc.enabled" = "false"
    "RemoteDisplay.vnc.port"    = "5900"
  }
  vmx_remove_ethernet_interfaces = true
  vnc_port_max                   = 5980
  vnc_port_min                   = 5900
  winrm_password                 = "vagrant"
  winrm_timeout                  = "${var.winrm_timeout}"
  winrm_username                 = "vagrant"
}

build {
  sources = [
    "source.hyperv-iso.windows_10",
    "source.parallels-iso.windows_10",
    "source.qemu.windows_10",
    "source.virtualbox-iso.windows_10",
    "source.vmware-iso.windows_10"
  ]

  provisioner "windows-shell" {
    execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
    remote_path     = "/tmp/script.bat"
    scripts         = ["./scripts/enable-rdp.bat"]
  }

  provisioner "powershell" {
    scripts = [
      "./scripts/vm-guest-tools.ps1",
      "./scripts/debloat-windows.ps1"
    ]
  }

  provisioner "windows-restart" {
    restart_timeout = "${var.restart_timeout}"
  }

  provisioner "powershell" {
    scripts = [
      "./scripts/set-powerplan.ps1",
      "./scripts/docker/disable-windows-defender.ps1"
    ]
  }

  provisioner "windows-shell" {
    execute_command = "{{ .Vars }} cmd /c \"{{ .Path }}\""
    remote_path     = "/tmp/script.bat"
    scripts         = [
      "./scripts/pin-powershell.bat",
      "./scripts/compile-dotnet-assemblies.bat",
      "./scripts/set-winrm-automatic.bat",
      "./scripts/uac-enable.bat",
      "./scripts/dis-updates.bat",
      "./scripts/compact.bat"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact  = false
    output               = "windows_10_<no value>.box"
    vagrantfile_template = "vagrantfile-windows_10.template"
  }
}
