@test "Check if the file exists" {
  run ls info.txt
  [ "$status" -eq 0 ]
}
