#!/bin/bash

# Create a VirtualBox image for Windows 10 using the provided product key.
#
# Prior to creating the image, this script dynamically creates a temporary
# "autounattend.xml" file which includes the provided product key. It supplies
# this file to the `packer` utility and destroys the file when the command is
# complete (regardless of the command's outcome).
#
# The upstream Packer configuration project encourages consumers to insert the
# sensitive key material directly into version-controlled files. This makes
# sharing the files difficult. The indirection implemented by this script
# automates the process and reduces the margin of error that comes from editing
# machine-readable files such as `autounattend.xml`.

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo A Windows product key must be provided as the first argument to this script. >&2
  exit 1
fi

windows_product_key=$1

temporary_directory=$(mktemp --directory --suffix .windows-packer)
temporary_auto_unattend_file=${temporary_directory}/Autounattend.xml

sed "s/WINDOWS_PRODUCT_KEY/${windows_product_key}/" \
  < ./answer_files/10/Autounattend.xml \
  > ${temporary_auto_unattend_file}

function cleanup {
  rm -rf ${temporary_directory}
}

trap cleanup EXIT

packer build \
  --except=vagrant \
  --only=virtualbox-iso \
  --var autounattend=${temporary_auto_unattend_file} \
  --var iso_checksum=sha256:7F6538F0EB33C30F0A5CBBF2F39973D4C8DEA0D64F69BD18E406012F17A8234F \
  --var iso_url=./Win10_21H2_English_x64.iso \
  windows_10.json
