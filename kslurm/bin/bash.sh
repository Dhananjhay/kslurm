# This represents a fairly significant load time for shells. A clever way of caching would be ideal
export KSLURM_LOGIN_NODES=$(sinfo -N -h | awk '{print $1'} | sort -u)

pip () {
  (
    [[ $1 == install || $1 == wheel || $1 == download ]] && installtype=1 || installtype=
    cmd=$1
    if [[ $KSLURM_LOGIN_NODES =~ $(hostname) && -n $installtype ]]; then
      cmd="$cmd --no-index"
    fi
    if [[ -n $installtype ]]; then
      if command -v kslurm &> /dev/null; then
        pipdir=$(kslurm config pipdir)
        if [[ -z $pipdir ]]; then
          echo "pipdir has not been defined. Please set a pipdir using \`kslurm config pipdir <directory>\`. Typically, this should be a directory in a project space or permanent storage directory."
        else
          wheelhouse="${pipdir%/}/wheels"
          if [[ ! -d $wheelhouse ]]; then
            mkdir -p $wheelhouse
          fi
          cmd="$cmd --find-links=$wheelhouse"
          export PIP_WHEEL_DIR=$wheelhouse
        fi
      else
        echo "kslurm program was not found on \$PATH. If installed in a virtualenv, be sure the env is activated."
      fi
    fi
    shift
    command pip $cmd $@
  )
}