# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.regression import TestFactory
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Test")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset the DUT
    dut._log.info("Applying Reset")
    dut.rst_n.value = 0  # Active low reset
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 10)  # Hold reset for some cycles
    dut.rst_n.value = 1  # Release reset
    await ClockCycles(dut.clk, 1)

    # Enable the DUT
    dut.ena.value = 1

    # Test various input cases
    test_cases = [
        (0x00, 0),   # Test with ui_in = 0x00, expect uo_out[0] = 0
        (0x01, 0),   # Test with ui_in = 0x01, expect uo_out[0] = 0
        (0x02, 0),
        (0x03, 1),   # Test with ui_in = 0x03, expect uo_out[0] = 1
        (0x04, 0),   # Test with ui_in = 0x04, expect uo_out[0] = 0
        (0x05, 1),
        (0x06, 1),
        (0x07, 1)    # Test with ui_in = 0x07, expect uo_out[0] = 1
    ]

    for ui_value, expected_output in test_cases:
        dut.ui_in.value = ui_value
        await ClockCycles(dut.clk, 1)  # Wait for one clock cycle

        # Check the output
        dut._log.info(f"Input: {ui_value:#04x}, Output: {dut.uo_out.value}")

        # Assert the expected output
        assert dut.uo_out[0].value == expected_output, f"Failed for input {ui_value:#04x}: expected {expected_output}, got {dut.uo_out[0].value}"

    dut._log.info("All tests completed successfully.")
