ui = true
disable_mlock = "true"

storage "file" {
  path    = "/vault/data"
}

listener "tcp" {
  address = "[::]:8200"
  tls_disable = "true"
}