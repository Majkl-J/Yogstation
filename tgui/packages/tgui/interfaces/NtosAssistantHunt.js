import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Box, Button, Knob, Section } from 'tgui/components';
import { Window, NtosWindow } from 'tgui/layouts';

export const NtosAssistantHunt = (props, context) => {
  return (
    <NtosWindow
      width={700}
      height={700}>
      <NtosWindow.Content>
        <AssistantHuntContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};


export const AssistantHuntContent = (props, context) => {
  const { act, data } = useBackend(context);

  return(
    <Section
      title="Assistant Hunt"
      style={{ width:'100%', height:'100%' }}
      onClick={() => act('PRG_Click', {
        x: clientX,
        y: clientY,
      })}
      >
        <img src={resolveAsset("AssistantHunt_Hos.png")}
        style={{ position:'absolute', left:'200px', top:'200px' }}
        />
    </Section>
  );
};

