#! /usr/bin/env bash

[ "${TRACE}" = 'YES' ] && set -x && : "$0" "$@"

install_mulle_clang_project()
{
   local is_prerelease
   local packagename
   local provider
   local repo
   local version

   is_prerelease='NO'
   packagename="mulle-clang"
   provider="github"
   repo="mulle-clang-project"

   case "${GITHUB_REF}" in
      */prerelease|*/*-prerelease)
         is_prerelease='YES'
      ;;
   esac

   if [ "${MULLE_HOSTNAME}" = "ci-prerelease" ]
   then
      is_prerelease='YES'
   fi

   case "${MULLE_UNAME}" in
      darwin)
         if [ "${is_prerelease}" = 'YES' ]
         then
            brew install mulle-objc/prerelease/mulle-clang-project
            return $?
         else
            brew install mulle-objc/software/mulle-clang-project
            return $?
         fi
      ;;

      linux)  
         LSB_RELEASE="${LSB_RELEASE:-`lsb_release -c -s`}"
         lsb_release -a >&2

         case "$LSB_RELEASE" in
            plucky|oracular|noble|mantic|lunar|kinetic|trixie|forky|bookworm|2[432]\.*) # broken catthehacker image fix for act
               codename="bookworm"
               version="17.0.6.2" # default
            ;;

            # jammy is actually bullseye, not bookworm as documented
            focal|groovy|hirsute|impish|jammy|bullseye|21\.*|20\.*)
               codename="bullseye"
               version="17.0.6.2"
            ;;

            bionic|buster|18\.*)
               codename="buster"
               version="14.0.6.2"
            ;;

            *)
               echo "Unsupported debian/ubuntu release \"${LSB_RELEASE}\"" >&2
               exit 1
            ;;
         esac
      ;;

      *)
         echo "Unsupported OS ${MULLE_UNAME}" >&2
         exit 1
      ;;
   esac

   local rc

   if [ "${is_prerelease}" = 'YES' ]
   then
      : # rc="-RC1"  # change at release back to ""
   fi

   local filename
   local architecture

   architecture="`dpkg --print-architecture`"
   filename="${packagename}-${version}${rc}-${codename}-${architecture}.deb"

   local url

   case "${provider}" in
      github)
         url="https://github.com/mulle-cc/${repo}/releases/download/${version}${rc}"
      ;;
   esac

   url="${url}/${filename}"

   echo "Downloading ${url} ..." >&2

   local sudo

   if command -v "sudo" > /dev/null
   then
      sudo="sudo"
   fi

   curl -L -O "${url}" &&
   ${sudo} dpkg --install "${filename}"
}


MULLE_UNAME="`uname | tr '[A-Z]' '[a-z]'`"
MULLE_UNAME="${MULLE_UNAME%%_*}"
MULLE_UNAME="${MULLE_UNAME%64}"


#
# images that have mulle-sde already installed, skip...
#
if PATH="${HOME}/bin:${PATH}" command -v mulle-clang > /dev/null
then
   echo "mulle-clang is already installed" >&2
   exit 0
fi

install_mulle_clang_project
