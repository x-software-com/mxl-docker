#!/usr/bin/env bash
set -e
set -x

main() {
  yum -y install epel-release p7zip
  yum clean all
  rm -rf /var/cache/yum

  # cairo is installed as workround! appimagetool currently (2018-08-24) requires cairo
  yum -y install cairo redhat-lsb-core
  yum clean all
  rm -rf /var/cache/yum

  pushd /tmp

  curl -LO https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
  chmod +x appimagetool-x86_64.AppImage
  pushd /opt
  /tmp/appimagetool-x86_64.AppImage --appimage-extract
  mv squashfs-root appimagetool
  popd
  ln -s /opt/appimagetool/AppRun /usr/local/bin/appimagetool
  rm appimagetool-x86_64.AppImage

  curl -LO https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
  chmod +x linuxdeploy-x86_64.AppImage
  pushd /opt
  /tmp/linuxdeploy-x86_64.AppImage --appimage-extract
  mv squashfs-root linuxdeploy
  popd
  ln -s /opt/linuxdeploy/AppRun /usr/local/bin/linuxdeploy
  rm linuxdeploy-x86_64.AppImage
  mv /opt/linuxdeploy/usr/bin/patchelf /opt/linuxdeploy/usr/bin/patchelf.binary
  mv patchelf.sh /opt/linuxdeploy/usr/bin/patchelf
  ln -s /opt/linuxdeploy/usr/bin/patchelf /usr/local/bin

  curl -LO https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-gtk/master/linuxdeploy-plugin-gtk.sh
  patch -u linuxdeploy-plugin-gtk.sh -i linuxdeploy-plugin-gtk.patch
  chmod +x linuxdeploy-plugin-gtk.sh
  mv linuxdeploy-plugin-gtk.sh /usr/local/bin

  curl -LO https://raw.githubusercontent.com/linuxdeploy/linuxdeploy-plugin-gstreamer/master/linuxdeploy-plugin-gstreamer.sh
  chmod +x linuxdeploy-plugin-gstreamer.sh
  mv linuxdeploy-plugin-gstreamer.sh /usr/local/bin

  curl -LO https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/releases/download/continuous/linuxdeploy-plugin-appimage-x86_64.AppImage
  chmod +x linuxdeploy-plugin-appimage-x86_64.AppImage
  pushd /opt
  /tmp/linuxdeploy-plugin-appimage-x86_64.AppImage --appimage-extract
  mv squashfs-root linuxdeploy-plugin-appimage
  popd
  ln -s /opt/linuxdeploy-plugin-appimage/AppRun /usr/local/bin/linuxdeploy-plugin-appimage
  rm linuxdeploy-plugin-appimage-x86_64.AppImage

  popd
}

main $@
