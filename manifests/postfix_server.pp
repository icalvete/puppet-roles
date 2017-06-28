class roles::postfix_server () {

  $mail_packages = ['postfix', 'mailutils']

  package { $mail_packages:
    ensure  => present
  }
}
