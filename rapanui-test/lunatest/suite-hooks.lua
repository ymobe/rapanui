module(..., package.seeall)

function suite_setup()
   print "\n\n-- running suite setup hook"
end

function suite_teardown()
   print "\n\n-- running suite teardown hook"
end

function test_ok()
   assert_true(true)
end
