# .bashrc

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

echo "";
echo "FlyingFlip Studios, LLC - Platform Linux Container";
echo "Version $VERSION - $BUILD_DATE";
echo "--------------------------------------------------";
echo ""
