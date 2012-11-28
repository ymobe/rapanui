--
-- Author: Janne Sinivirta
-- Date: 9/19/12
--
require('lunatest')
require('lunahamcrest')

function test_equal_to()
    assert_that(4, equal_to(4))
    assert_that("ok", equal_to("ok"))
end

function test_not()
    assert_that(4, is_not(equal_to(5)))
    assert_that(5, is_not(is_nil()))
end

function test_syntactic_sugars()
    assert_that(4, is(equal_to(4)))
    assert_that(nil, is_nil())
end

function test_of_type()
    assert_that("test", is(of_type("string")))
    assert_that(4, is(of_type("number")))
end

function test_contains_string()
    assert_that("testable", contains_string("test"))
    assert_that("testable", contains_string("tab"))
    assert_that("testable", contains_string("testable"))
end

function test_starts_with()
    assert_that("testable", starts_with("tes"))
    assert_that("testable", starts_with("testable"))
end

function test_starts_with()
    assert_that("testable", equals_ignoring_case("tesTaBlE"))
end

lunatest.run()
