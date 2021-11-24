class Info {
  String ROOT = "http://172.16.0.2:9000";

  String getAPIRegister() {
    return "$ROOT/api/v1/auth/register";
  }

  String getAPILogin() {
     return "$ROOT/api/v1/auth/login";
  }
}