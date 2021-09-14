import pytest
from cluster_utils.slurm.helpers import div_remainder, slurm_time_format
from hypothesis import given, strategies as st
from cluster_utils.slurm.slurm_args import formatters

@given(num=st.integers(), denom=st.integers())
def test_div_remainder(num: int, denom: int):
    if denom == 0:
        with pytest.raises(AssertionError):
            div_remainder(num, denom)
    else:
        res, rem = div_remainder(num, denom)
        assert (res * denom) + rem == num

@given(min=st.integers(min_value=0))
def test_slurm_time_format(min: int):
    res = slurm_time_format(min)
    # Strip off last ":00", which won't be recognized by the formatter
    assert formatters.time(res[:-3]) == min