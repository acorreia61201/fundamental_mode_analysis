# calculate the expected parameters from an injection file

from pycbc.conversions import final_mass_from_initial, final_spin_from_initial
from pycbc.cosmology import redshift
from pycbc.constants import MTSUN_SI

def expected_params(m1, m2, distance, inc, s1x=0, s1y=0, s1z=0, s2x=0, s2y=0, s2z=0):
     z = redshift(distance)
     mf = (1 + z) * final_mass_from_initial(m1, m2, s1x, s1y, s1z, s2x, s2y, s2z)
     chif = final_spin_from_initial(m1, m2, s1x, s1y, s1z, s2x, s2y, s2z)
     t0 = mf * MTSUN_SI
     print("--expected-parameters")
     print(f"\t 'ringdown__final_mass:{mf}' \\")
     print(f"\t 'ringdown__final_spin:{chif}' \\")
     print("\t 'ra: 3.5' \\")
     print("\t 'dec: 0.73' \\")
     print(f"\t '(delta_tc + t_switch)/{t0}:10' \\")
     print(f"\t 'inclination:{inc}' \\")
