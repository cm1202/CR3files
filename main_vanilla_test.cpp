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
   // slow to fast.
   const uint32_t blink_periods_ms[] = {1000, 500, 200, 100};
   const int num_periods = sizeof(blink_periods_ms) / sizeof(blink_periods_ms[0]);

   // Drive only the selected LED and prime the blink period so the LED begins
   // toggling as soon as the main loop starts.
   led.write(0);
   led.write(blink_pattern);
   led.set_blink_period_ms(blink_periods_ms[0]);

   while (1) {
      // Cycle through the list of blink rates. Holding each setting for a few
      // seconds makes the different speeds easy to observe on the board.
      for (int i = 0; i < num_periods; i++) {
         led.set_blink_period_ms(blink_periods_ms[i]);
         sleep_ms(4000);
      }
   }

   return 0;
}
