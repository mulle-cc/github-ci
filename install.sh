#! /usr/bin/env bash

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
   version="14.0.6.2"

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
         if dpkg -s "${packagename}" > /dev/null 2>&1
         then
            return
         fi

         LSB_RELEASE="${LSB_RELEASE:-`lsb_release -c -s`}"
         lsb_release -a >&2

         case "$LSB_RELEASE" in
            # jammy is actually bullseye, not bookworm as documented
            jammy)
               codename="bullseye"
            ;;

            kinetic|bookworm|22\.*) # broken catthehacker image fix for act
               codename="bookworm"
            ;;

            focal|groovy|hirsute|impish|jammy|bullseye|21\.*|20\.*)
               codename="bullseye"
            ;;

            bionic|buster|18\.*)
               codename="buster"
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

   filename="${packagename}-${version}${rc}-${codename}-amd64.deb"

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


install_mulle_clang_project
