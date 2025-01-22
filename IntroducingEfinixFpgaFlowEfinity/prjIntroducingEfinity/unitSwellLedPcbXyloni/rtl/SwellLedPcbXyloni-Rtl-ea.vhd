-------------------------------------------------------------------------------
-- Title      : SwellLedForMemoXc2sPB_e
-- Project    : SwellLed
-------------------------------------------------------------------------------
-- See specification text.
-- Also some rudimentary synchronization of asynchronous inputs is done here
-- using a chain of two FlipFlops for the key inputs.
-------------------------------------------------------------------------------
-- Copyright (c) 2000 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2000/03/08  1.0      pfaff   Created
-- 6Sep01               pfaff   Revised for SpartanIIProtoBoard
-- 2003/04/23           vogg    Revised for Sandbox (SpartanIIProtoBoard V2.0)
-- 2015/10/08           pfaff   Revised for DE1-SoC
-- 2023-10-27           pfaff   Revised for Efinix Xzloni Board
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SwellLedPcbXyloni is

  port (Clk : in std_ulogic;

        BTN1 : in  std_ulogic;
        BTN2 : in  std_ulogic;
        LED1 : out std_ulogic;
        LED2 : out std_ulogic := '0';
        LED3 : out std_ulogic := '0';
        LED4 : out std_ulogic := '0'
        );

end SwellLedPcbXyloni;

architecture Rtl of SwellLedPcbXyloni is

  signal DimmKey, BrightenKey : std_ulogic;
  signal Led                  : std_ulogic;

begin

  TheSwellLed : entity work.SwellLed(Rtl)
    generic map (
      gClkFrequency => 50E6,
      gPwmRate      => 2E3)
    port map (
      iClk         => Clk,
      inResetAsync => not('0'),
      iDimmKey     => DimmKey,
      iBrightenKey => BrightenKey,
      oLed         => Led);

  LED1        <= Led;
  LED2        <= Led;
  LED3        <= Led;
  LED4        <= Led;
  DimmKey     <= not(BTN1);
  BrightenKey <= not(BTN2);

end Rtl;
