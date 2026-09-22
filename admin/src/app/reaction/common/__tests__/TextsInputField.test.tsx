import { describe, expect, it, vi } from 'vitest';
import { fireEvent, render, screen } from '@testing-library/react';
import TextsInputField from '../TextsInputField';

describe('TextsInputField', () => {
  it('texts の数だけ入力欄を描画する', () => {
    render(
      <TextsInputField
        label="suggestions"
        name="サジェスチョン"
        texts={['a', 'b']}
        onTextsChange={vi.fn()}
        onTextsDelete={vi.fn()}
        onTextsAdd={vi.fn()}
      />
    );
    expect(screen.getByText('サジェスチョン')).toBeInTheDocument();
    const inputs = screen.getAllByRole('textbox');
    expect(inputs).toHaveLength(2);
    expect(inputs[0]).toHaveValue('a');
    expect(inputs[1]).toHaveValue('b');
  });

  it('入力・削除・追加でそれぞれのコールバックが index 付きで呼ばれる', () => {
    const onTextsChange = vi.fn();
    const onTextsDelete = vi.fn();
    const onTextsAdd = vi.fn();
    render(
      <TextsInputField
        label="suggestions"
        name="サジェスチョン"
        texts={['a', 'b']}
        onTextsChange={onTextsChange}
        onTextsDelete={onTextsDelete}
        onTextsAdd={onTextsAdd}
      />
    );

    fireEvent.change(screen.getAllByRole('textbox')[1], {
      target: { value: 'changed' },
    });
    expect(onTextsChange).toHaveBeenCalledTimes(1);
    expect(onTextsChange.mock.calls[0][1]).toBe(1);

    const buttons = screen.getAllByRole('button');
    // 削除ボタン2つ + 追加ボタン1つ
    expect(buttons).toHaveLength(3);
    fireEvent.click(buttons[0]);
    expect(onTextsDelete).toHaveBeenCalledWith(0);
    fireEvent.click(buttons[2]);
    expect(onTextsAdd).toHaveBeenCalledTimes(1);
  });
});
