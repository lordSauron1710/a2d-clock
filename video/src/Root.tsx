import React from "react";
import { Composition } from "remotion";
import { Showcase } from "./Showcase";

// 800×300 — fits the clock grid's ~2.85:1 aspect ratio with comfortable padding
// 390 frames at 30 fps = 13 seconds
export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="Showcase"
      component={Showcase}
      durationInFrames={650}
      fps={50}
      width={600}
      height={225}
    />
  );
};
