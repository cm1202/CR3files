/*****************************************************************//**
 * @file main_vanilla_test.cpp
 *
 * @brief Demonstrate blinking a single LED at multiple rates.
 *
 * @author p chu
 * @version v1.1: updated to exercise blinking gpo core
 *********************************************************************/

#include "chu_init.h"
#include "gpio_cores.h"

// Instantiate the enhanced LED core located in slot 2. Slot 2 now hosts the
// blinking GPO peripheral so software can control intensity and blink timing.
GpoCore led(get_slot_addr(BRIDGE_BASE, S2_LED));

int main() {
   const int led_index = 0;
   // Only one LED is animated; compute the mask once to avoid repetitive math
   // inside the timing loop.
   const uint32_t blink_pattern = 1u << led_index;
   // A short menu of blink intervals that exercise the speed register from
   // slow to fast. The hardware register expects milliseconds, so we store the
   // values in a 16-bit array that matches the driver API.
   const uint16_t blink_periods_ms[] = {1000, 500, 200, 100};
   const int num_periods = sizeof(blink_periods_ms) / sizeof(blink_periods_ms[0]);

   // The GPO driver exposes helper methods that mirror the hardware features:
   //  - set_mask() loads the DATA register with a bitmap of LEDs to blink.
   //  - set_speed_ms() updates the SPEED register that controls the blink rate.
   //  - set_blink() writes both registers in a single transaction.
   // Using them keeps the software in sync with the peripheral’s cached state.

   // Start by clearing any previous LED pattern, then arm the blinker with our
   // single-LED mask and the slowest blink speed. set_blink() ensures that the
   // mask is written before the speed change takes effect.
   led.set_mask(0);
   led.set_blink(blink_pattern, blink_periods_ms[0]);

   while (1) {
      // Cycle through the list of blink rates. Holding each setting for a few
      // seconds makes the different speeds easy to observe on the board. Only
      // the speed register needs to be updated after the mask is established.
      for (int i = 0; i < num_periods; i++) {
         led.set_speed_ms(blink_periods_ms[i]);
         sleep_ms(4000);
      }
   }

   return 0;
}
