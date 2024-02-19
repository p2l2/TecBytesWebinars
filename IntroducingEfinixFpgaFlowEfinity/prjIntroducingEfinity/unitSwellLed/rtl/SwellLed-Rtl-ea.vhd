-------------------------------------------------------------------------------
-- Project    : SwellLed for Efinix T8BGA81DevKit
-- P2L2 GmbH, 2024, copyright (c)
-- Author: Markus Pfaff
-------------------------------------------------------------------------------
-- Warning! Warning! Warning! Warning! Warning! Warning! Warning! Warning!
-------------------------------------------------------------------------------
-- This description is based on synchronized inputs at the keys and a 
-- reset signal synchronized on deactiviation. 
-- To keep the description simple for evaluation purposes we omitted
-- synchronization, which is of course not feasable for production use!
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity SwellLed is

  generic (
    gClkFrequency : natural := 40E6;    -- frequency of system clk
    gPwmRate      : natural := 2E3);    -- frequency of PWM for LED

  port (
    iClk         : in std_ulogic;    -- system clock
    inResetAsync : in std_ulogic;    -- global asynchronous reset

    iDimmKey     : in  std_ulogic;                      -- synchronized signal from dimming key
    iBrightenKey : in  std_ulogic;                      -- synchronized signal from brightening key
    oLed         : out std_ulogic_vector(4 downto 0));  -- led which shall be dimmable

end SwellLed;


architecture Rtl of SwellLed is

  -- Determining the number of bits we need using the logarithm dualis of the cyclic counter. 
  -- (Thereby putting VHDL 2008 to use.)
  constant cCycleBitCount : natural := natural(ceil(log2(real(gClkFrequency)/real(gPwmRate))));

  -- The counter which goes from 0 to maximum during each cycle
  signal PlaceInCycle : unsigned(cCycleBitCount-1 downto 0);
  -- The value that marks the change from on to off state for the Led.
  -- This is the value that the user can set by the buttons.
  signal Brightness   : unsigned(cCycleBitCount-1 downto 0);

  -- What the user commands by pressing the two buttons will be combined in this vector.
  signal UserCommand : std_ulogic_vector(1 downto 0);

begin

  -- Because we'd like to use a case statement later on we combine all user input
  -- in a single vector.
  UserCommand <= iDimmKey & iBrightenKey;

  -- Practically the complete functionality is described in a single sequential process.
  -- The modelling idea here is an FSM with a state distributed over two state
  -- registers, namely PlaceInCycle and Brightness.
  -- 
  -- Since the inputs of this unit only influence the state registers and the registers
  -- are the direct output of the FSM (aka Medwedew FSM) we can use a single process 
  -- for our model.
  -- In case the outputs would be encoded from the state registers (aka Moore FSM)
  -- and in addition the inputs would influence the outputs combinatorially (aka Mealy FSM)
  -- using a single process would be a very bad idea, because it would at least
  -- lead to mismatches between simulation and synthesis.
  CountAndAdjust : process (iClk, inResetAsync)

  begin
    -- The asynchronous reset is active low (that is what the 'n' after the 'i' at the
    -- beginning of the name says). Using negative logic is a pain. We shift that pain
    -- over to synthesis by negating a positive logic '1' here. The 'n' on the left
    -- corresponds to the not() on the right.
    if inResetAsync = not('1') then

      PlaceInCycle <= to_unsigned(0, PlaceInCycle'length);
      Brightness   <= to_unsigned(0, Brightness'length);

    elsif rising_edge(iClk) then

      -- the Counter is always running through the full cycle
      -- the value given by the user for PWM rate is not followed exactly
      PlaceInCycle <= (PlaceInCycle + 1) mod (2**cCycleBitCount);

      -- adjustment happens once per cycle
      if PlaceInCycle = 0 then
        -- adjust Brightness according to the keys pressed
        case UserCommand is

          when "10" =>
            -- Dimm the light slowly
            if Brightness /= 0 then
              Brightness <= Brightness - 1;
            end if;
            
          when "01" =>
            -- Brighten the light slowly
            if Brightness /= (2**cCycleBitCount)-1 then
              Brightness <= Brightness + 1;
            end if;

          when "11" =>
            -- Dimm the light the fast way
            if Brightness < 20 then
              -- fast, but without overshooting
              if Brightness /= 0 then
                Brightness <= Brightness - 1;
              end if;
            else
              -- this is what is meant by "fast"
              Brightness <= Brightness - 10;
            end if;

          when "00" =>
            -- Do nothing if no or both keys are pressed
            null;

          when others =>
            -- Synthesis will ignore this, but simulation would not be complete without it
            Brightness <= (others => 'X');
        end case;
      end if;

    end if;

  end process CountAndAdjust;

  -- Encoding of the output is done outside the FSM process.
  -- When does the LED light up?
  -- The LEDs will dimm and brighten faster the higher the multiplier of the
  -- Brightness is set.
  -- Multiplication by a constant will be realized by Efinity quite efficiently
  -- using only little LUT4 resources (instead of the hardware multipliers the
  -- FPGA supplies also). Even so if the constant is not of the form 2**n.
  oLed(0) <= '1' when PlaceInCycle < Brightness else
             '0';
  oLed(1) <= '1' when PlaceInCycle < 2*Brightness else
             '0';
  oLed(2) <= '1' when PlaceInCycle < 3*Brightness else
             '0';
  oLed(3) <= '1' when PlaceInCycle < 6*Brightness else
             '0';
  oLed(4) <= '1' when PlaceInCycle < 12*Brightness else
             '0';
                
end Rtl;
