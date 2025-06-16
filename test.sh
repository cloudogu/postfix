                          if git show-ref --verify --quiet refs/remotes/origin/main; then
                              echo main
                          elif git show-ref --verify --quiet refs/remotes/origin/master; then
                              echo master
                          else
                              echo ""
                          fi
