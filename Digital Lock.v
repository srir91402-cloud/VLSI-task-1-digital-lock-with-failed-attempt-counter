module digital_lock (
    input  wire       clk,
    input  wire       reset,       // active-high reset
    input  wire [3:0] code_in,     // code set by switches
    input  wire       submit,      // one-clock pulse, already debounced
    output reg        unlock,
    output reg        lockout,
    output reg  [1:0] failed       // optional: show count on LEDs
);

    localparam [1:0] LOCKED   = 2'b00,
                     UNLOCKED = 2'b01,
                     LOCKOUT  = 2'b10;
                     LOCKOUT  = 2'b10;

    localparam [3:0] PASSCODE = 4'b1010;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state  <= LOCKED;
            failed <= 2'd0;
        end else begin
            case (state)
                LOCKED: begin
                    if (submit) begin
                        if (code_in == PASSCODE) begin
                            failed <= 2'd0;
                            state  <= UNLOCKED;
                        end else if (failed == 2'd2) begin
                            failed <= 2'd3;
                            state  <= LOCKOUT;
                        end else begin
                            failed <= failed + 1'b1;
                        end
                    end
                end

                UNLOCKED: begin
                    // Remains unlocked until reset.
                end

                LOCKOUT: begin
                    // Remains locked out until reset.
                end

                default: begin
                    state  <= LOCKED;
                    failed <= 2'd0;
                end
            endcase
        end
    end

    always @* begin
        unlock = (state == UNLOCKED);
        lockout = (state == LOCKOUT);
    end

endmodule

