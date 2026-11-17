'use client';

import React from 'react';
import * as entity from '@/lib/entity';
import { NOTICE_LANGUAGES, NOTICE_PLATFORMS, toggleTarget } from '@/lib/notice';

type CheckboxGroupProps<T extends string> = {
  label: string;
  name: string;
  options: { value: T; label: string }[];
  values: T[];
  onChange: (values: T[]) => void;
};

function CheckboxGroup<T extends string>({
  label,
  name,
  options,
  values,
  onChange,
}: CheckboxGroupProps<T>) {
  return (
    <div className="reaction-edit-content">
      <p>{label}</p>
      {options.map((option) => (
        // .reaction-edit-content の label は block、input は幅 100% になっているため、
        // チェックボックスとラベルが縦に離れてしまう。ここだけ横並びに戻す
        <label
          key={option.value}
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '6px',
            marginRight: '24px',
          }}
        >
          <input
            style={{ width: 'auto' }}
            type="checkbox"
            name={name}
            value={option.value}
            checked={values.includes(option.value)}
            onChange={(e) =>
              onChange(
                toggleTarget(values, option.value, e.target.checked, options)
              )
            }
          />
          {option.label}
        </label>
      ))}
      <hr />
    </div>
  );
}

type Props = {
  platforms: entity.NoticePlatform[];
  languages: entity.NoticeLanguage[];
  onPlatformsChange: (platforms: entity.NoticePlatform[]) => void;
  onLanguagesChange: (languages: entity.NoticeLanguage[]) => void;
};

export default function NoticeTargetFields({
  platforms,
  languages,
  onPlatformsChange,
  onLanguagesChange,
}: Props) {
  return (
    <>
      <CheckboxGroup
        label="対象OS"
        name="platforms"
        options={NOTICE_PLATFORMS}
        values={platforms}
        onChange={onPlatformsChange}
      />
      <CheckboxGroup
        label="対象言語（チェックした言語のタイトルは必須）"
        name="languages"
        options={NOTICE_LANGUAGES}
        values={languages}
        onChange={onLanguagesChange}
      />
    </>
  );
}
