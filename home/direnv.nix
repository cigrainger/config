{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      layout_postgres() {
        export PGDATA="''$(direnv_layout_dir)/postgres"
        export PGHOST="''$PGDATA"
        if [[ ! -d "''$PGDATA" ]]; then
          initdb
          echo "listen_addresses = '''''\nunix_socket_directories = '$PGHOST'" > ''$PGDATA/postgresql.conf
          echo "CREATE DATABASE ''$USER;" | postgres --single -E postgres
        fi
      }
    '';
  };
}
