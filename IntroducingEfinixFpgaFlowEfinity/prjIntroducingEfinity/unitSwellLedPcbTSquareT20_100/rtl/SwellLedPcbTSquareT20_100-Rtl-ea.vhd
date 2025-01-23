-------------------------------------------------------------------------------
-- Project    : SwellLed for Efinix T8BGA81DevKit
-- P2L2 GmbH, 2024, copyright (c)
-- Author: Markus Pfaff
-------------------------------------------------------------------------------
-- PCB adapter description for SwellLed on Trion T8 BGA81 Dev Kit
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity SwellLedPcbTSquareT20_100 is
  generic (
    gClkFrequency : natural := 40E6;    -- frequency of system clk
    gPwmRate      : natural := 2E3);    -- frequency of PWM for LED

  -- This entity uses port names as they appear on the board schematics
  port (PLL_OUT : in std_ulogic;        -- PLL_IN: GPIOL_20_PLLIN, Pin C3

        S100  : in  std_ulogic;         -- GPIOL_12, Pin G1
        S101  : in  std_ulogic;         -- GPIOL_13, Pin F1
        D400  : out std_ulogic := '0';  -- GPIOL_03, Pin G4
        D401  : out std_ulogic := '0';  -- GPIOL_09, Pin J2
        D402  : out std_ulogic := '0';  -- GPIOL_16, Pin C2
        D404  : out std_ulogic := '0';  -- GPIOL_18, Pin E3
        Dnone : out std_ulogic := '0'   -- GPIOL_21, Pin B3
        );

end SwellLedPcbTSquareT20_100;

architecture Rtl of SwellLedPcbTSquareT20_100 is

  signal DimmKey, BrightenKey : std_ulogic;
  signal Led                  : std_ulogic_vector(4 downto 0);

begin

  -- Connect the design port names to the names used on the board
  TheSwellLed : entity work.SwellLed(Rtl)
    -- instance name => local name
    generic map (
      gClkFrequency => gClkFrequency,
      gPwmRate      => gPwmRate)
    port map (
      iClk         => PLL_OUT,
      inResetAsync => not('0'),
      iDimmKey     => DimmKey,
      iBrightenKey => BrightenKey,
      oLed         => Led);

  -- Design has positive logic, but board has negative
  D400        <= Led(0);
  D401        <= Led(1);
  D402        <= Led(2);
  D404        <= Led(3);
  Dnone       <= Led(4);
  DimmKey     <= not(S100);
  BrightenKey <= not(S101);

end Rtl;
