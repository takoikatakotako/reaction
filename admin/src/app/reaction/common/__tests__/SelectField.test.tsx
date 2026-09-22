import { describe, expect, it, vi } from 'vitest';
import { fireEvent, render, screen } from '@testing-library/react';
import SelectField from '../SelectField';

const options = ['Alcohol', 'Alkene/Alkyne', 'Amine'];

describe('SelectField', () => {
  it('選択済みの値ごとに select を描画し、現在値を反映する', () => {
    render(
      <SelectField
        label="reactants"
        name="反応物"
        options={options}
        selectedValues={['Alcohol', 'Amine']}
        onSelectionChange={vi.fn()}
        onSelectionAdd={vi.fn()}
        onSelectionDelete={vi.fn()}
      />
    );
    const selects = screen.getAllByRole('combobox');
    expect(selects).toHaveLength(2);
    expect(selects[0]).toHaveValue('Alcohol');
    expect(selects[1]).toHaveValue('Amine');
  });

  it('選択を変えると該当 index だけ差し替えた配列で onSelectionChange が呼ばれる', () => {
    const onSelectionChange = vi.fn();
    render(
      <SelectField
        label="reactants"
        name="反応物"
        options={options}
        selectedValues={['Alcohol', 'Amine']}
        onSelectionChange={onSelectionChange}
        onSelectionAdd={vi.fn()}
        onSelectionDelete={vi.fn()}
      />
    );
    fireEvent.change(screen.getAllByRole('combobox')[0], {
      target: { value: 'Alkene/Alkyne' },
    });
    expect(onSelectionChange).toHaveBeenCalledWith(['Alkene/Alkyne', 'Amine']);
  });
});
