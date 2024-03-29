require 'test_helper'

class CheckPinTest < ApiTest
  setup do
    @tournament.update(score_submit_pin: '1234')
    @output = '{ success }'
  end

  test "entering correct pin" do
    input = {pin: '1234'}
    execute_graphql("checkPin", "CheckPinInput", input, @output)
    assert_success
  end

  test "entering incorrect pin" do
    input = {pin: '5555'}
    execute_graphql("checkPin", "CheckPinInput", input, @output)
    assert_failure
  end
end
