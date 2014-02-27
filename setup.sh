unset PERL5LIB
. /data/current/sw*/slc*/cms/PHEDEX-micro/*/etc/profile.d/init.sh
. /data/current/sw*/slc*/cms/PHEDEX-lifecycle/*/etc/profile.d/init.sh
. /data/current/sw*/slc*/cms/asyncstageout/*/etc/profile.d/init.sh

# Remove old FakeFTS.pl from LifeCycle distribution!
(rm /data/current/sw*/slc*/cms/PHEDEX-lifecycle/*/bin/FakeFTS.pl) 2>/dev/null

# Add PHEDEX-micro Utilities to the PATH
export PATH=${PATH}:`ls -d /data/current/sw*/slc*/cms/PHEDEX-micro/*/Utilities`

export PERL5LIB=${PERL5LIB}:/data/wildish/monitor/perl_lib
