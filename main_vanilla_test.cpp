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

// Instantiate the vanilla LED core located in slot 2.
GpoCore led(get_slot_addr(BRIDGE_BASE, S2_LED));

int main() {
   const int led_index = 0;
   const uint32_t led_mask = 1u << led_index;

   while (1) {
      // Turn the selected LED on, wait, then turn it off again.
      led.write(led_mask);
      sleep_ms(500);

      led.write(0);
      sleep_ms(500);
   }

   return 0;
}
