module(..., package.seeall)

-- Either returning false or erroring out in suite_setup()
-- will prevent the suite from running.
function suite_setup()
   print "\n\n-- (about to fail and abort suite)"
   if true then return false end
   error("don't run this suite")
end

function test_never_run()
   assert_true(false, "this suite should never be run")
end
