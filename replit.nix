
{pkgs}: {
  deps = [
    pkgs.flutter
    pkgs.flet-client-flutter
    pkgs.rPackages.darts
    pkgs.protoc-gen-dart
    pkgs.darcs-to-git
    pkgs.sbclPackages.darts_dot_lib_dot_uuid-test
  ];
}
