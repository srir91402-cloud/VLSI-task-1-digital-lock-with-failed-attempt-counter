`timescale 1ns/1ps

module tb_digital_lock;

    reg        clk;
    reg        reset;
    reg  [3:0] code_in;
    reg        submit;
    wire       unlock;
    wire       lockout;
    wire [1:0] failed;

    // Device under test
    digital_lock dut (
        .clk     (clk),
        .reset   (reset),
        .code_in (code_in),
        .submit  (submit),
        .unlock  (unlock),
        .lockout (lockout),
        .failed  (failed)
    );

    // 100 MHz clock (10 ns period)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Apply submit for one clock edge, then release it.
    task enter_code;
        input [3:0] value;
        begin
            @(negedge clk);
            code_in = value;
            submit  = 1'b1;
            @(negedge clk);
            submit  = 1'b0;
            @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("digital_lock.vcd");
        $dumpvars(0, tb_digital_lock);

        reset   = 1'b1;
        code_in = 4'b0000;
        submit  = 1'b0;

        // Reset and check initial state
        repeat (2) @(negedge clk);
        reset = 1'b0;
        @(negedge clk);

        if (unlock !== 1'b0 || lockout !== 1'b0 || failed !== 2'd0)
            $fatal(1, "FAIL: Incorrect initial state");

        // First and second wrong attempts
        enter_code(4'b0001);
        if (failed !== 2'd1 || lockout !== 1'b0)
            $fatal(1, "FAIL: First incorrect attempt not counted");

        enter_code(4'b0010);
        if (failed !== 2'd2 || lockout !== 1'b0)
            $fatal(1, "FAIL: Second incorrect attempt not counted");

        // Third consecutive wrong attempt should lock out
        enter_code(4'b0011);
        if (failed !== 2'd3 || lockout !== 1'b1 || unlock !== 1'b0)
            $fatal(1, "FAIL: Third incorrect attempt did not cause lockout");

        // Correct code must not clear lockout without reset
        enter_code(4'b1010);
        if (lockout !== 1'b1 || unlock !== 1'b0)
            $fatal(1, "FAIL: Lockout was cleared without reset");

        // Reset should clear lockout and failure count
        reset = 1'b1;
        repeat (2) @(negedge clk);
        reset = 1'b0;
        @(negedge clk);

        if (failed !== 2'd0 || lockout !== 1'b0 || unlock !== 1'b0)
            $fatal(1, "FAIL: Reset did not clear lockout and count");

        // A correct code should unlock
        enter_code(4'b1010);
        if (unlock !== 1'b1 || lockout !== 1'b0 || failed !== 2'd0)
            $fatal(1, "FAIL: Correct code did not unlock");

        // Wrong entries while unlocked should not relock it
        enter_code(4'b0001);
        if (unlock !== 1'b1 || lockout !== 1'b0)
            $fatal(1, "FAIL: Lock state changed after unlocking");

        $display("PASS: All digital lock tests passed.");
        $finish;
    end

    initial begin
        #2000;
        $fatal(1, "FAIL: Testbench timed out");
    end

endmodule
