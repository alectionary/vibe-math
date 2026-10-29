"""Full-basis oracle with an explicit final cap checkpoint and sparse heartbeat."""
import time
from conditional_span_oracle import ConditionalSpanOracle
class BoundedSpanOracle(ConditionalSpanOracle):
    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs);self.cap_reported=False
    def check(self):
        super().check()
        if self.progress and self.stats['cut_limit_reached']:
            now=time.monotonic()
            if not self.cap_reported or now-self.last_progress>=30:
                self.cap_reported=True;self.progress(self.stats.copy());self.last_progress=now
