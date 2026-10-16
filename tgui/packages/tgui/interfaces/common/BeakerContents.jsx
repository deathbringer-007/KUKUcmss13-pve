import { AnimatedNumber, Box } from '../../components';

export const BeakerContents = (props) => {
  const { beakerLoaded, beakerContents } = props;
  return (
    <Box>
      {(!beakerLoaded && <Box color="label">未装入烧杯。</Box>) ||
        (beakerContents.length === 0 && (
          <Box color="label">烧杯为空。</Box>
        ))}
      {beakerContents.map((chemical) => (
        <Box key={chemical.name} color="label">
          <AnimatedNumber initial={0} value={chemical.volume} />
          {' 单位' + chemical.name}
        </Box>
      ))}
    </Box>
  );
};
