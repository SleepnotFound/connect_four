# connect_four

part of the odin project curriculum


my notes:
for finding diagonal wins.
diagonals go 2 directions downleft(/) and downright(\)
a 4-piece win is only possible starting from row 4 to 6.(row 0 is very bottom)
downlefts(/) only possible from column 1 to 4
downrights(\) only possible from column 4 to 7
loop through row 4-6
  which will loop through column 1-4
    check for 4-piece downright(\)
  which will loop through column 4-7
    check for 4-piece downlefts(/)
  if no match return false
