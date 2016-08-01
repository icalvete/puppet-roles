class roles::omd_server (

  $labs_edition = false

) inherits roles {

  class {'omd':
    labs_edition => $labs_edition
  }
}
