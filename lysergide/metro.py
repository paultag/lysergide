from collections import defaultdict
import asyncio


class Metronome(object):
    def __init__(self, bpm, bar):
        self.beats = []
        self.bpm = bpm
        self.bar = bar

    def register(self, callback):
        self.beats.append(callback)

    @asyncio.coroutine
    def __call__(self):
        # This sucks. Compute sleep time.
        beat = 0
        while True:
            yield from asyncio.sleep(0.12)
            for cb in self.beats:
                asyncio.async(cb(beat))
            beat = ((beat + 1) % self.bar)
