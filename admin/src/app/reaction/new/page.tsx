'use client';

import React, { useState, ChangeEvent, FormEvent } from 'react';


export default function AboutPage() {

      const [name, setName] = useState<string>(''); // 入力された名前を文字列として管理
    
      // 入力変更時のイベントハンドラ
      const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
        setName(e.target.value);
      };
    
      // フォーム送信時のイベントハンドラ
      const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
        e.preventDefault(); // ページのリロードを防ぐ
        alert(`送信された名前: ${name}`);
        // ここでAPI通信や他の処理ができる
      };
    
    
    return (
<main className="wrapper">
<h1>反応機構追加</h1>

<form>
    <div className="reaction-edit-content">
        <label htmlFor="englishName">EnglishName</label>
        {/* <input type="text" name="englishName" value="Acetoacetic Ester Synthesis" /> */}
        <input
          type="text"
          name="englishName"
          value={name}
          onChange={handleChange}
        />
        <hr/>
    </div>

    <div className="reaction-edit-content">
        <label htmlFor="japanseeName">JapaneseName</label>
        <input type="text" name="japanseeName" value="アセト酢酸エステル合成" />
        <hr/>
    </div>

    <div className="reaction-edit-content">
        <label htmlFor="thumbnail">Thumbnail</label>

        <div className="reaction-edit-image-container" >
            <img className="reaction-edit-image" src="/acetoacetic-ester-synthesis-thumbnail.png"/> 
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg"/></button>
        </div>
        <hr/>
    </div>

    <div className="reaction-edit-content">
        <label htmlFor="thumbnail">General Formulas</label>

        <div className="reaction-edit-image-container" >
            <img className="reaction-edit-image" src="/image-placeholder.png"/> 
            {/*  <button class="reaction-edit-image-delete-button"><img src="/image-delete.svg"/></button> */}
        </div>
        <hr/>
    </div>

    <div className="reaction-edit-content">
        <label htmlFor="thumbnail">Mechanisms</label>

        <div className="reaction-edit-image-container" >
            <img className="reaction-edit-image" src="/image-placeholder.png" /> 
            {/* <button class="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button> */}
        </div>
        <hr/>
    </div>

    <div className="reaction-edit-content">
        <label htmlFor="thumbnail">Examples</label>

        <div className="reaction-edit-image-container" >
            <img className="reaction-edit-image" src="/acetoacetic-ester-synthesis-thumbnail.png" /> 
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg"/></button>
        </div>

        <div className="reaction-edit-image-container" >
            <img className="reaction-edit-image" src="/image-placeholder.png"/> 
            {/* <button class="reaction-edit-image-delete-button"><img src="/image-delete.svg"/></button>*/}
        </div>
        <hr/>
    </div>

    <div className="reaction-edit-content">
        <label htmlFor="thumbnail">Supplements</label>

        <div className="reaction-edit-image-container" >
            <img className="reaction-edit-image" src="/acetoacetic-ester-synthesis-thumbnail.png" /> 
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button>
        </div>

        <div className="reaction-edit-image-container" >
            <img className="reaction-edit-image" src="/image-placeholder.png" /> 
            {/*  <button class="reaction-edit-image-delete-button"><img src="image/image-delete.svg"></button> */}
        </div>
        <hr/>
    </div>


    <div className="reaction-edit-content">
        <label htmlFor="englishName">Suggestions</label>
        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="Acetoacetic Ester Synthesis" />
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button>
        </div>
        <hr/>

        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="アセト酢酸エステル合成" />
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button>
        </div>
        <hr/>

        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="" placeholder="サジェスチョンの単語を入力" />
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button>
        </div>
        <hr/>

        <button className="reaction-edit-multi-input-plus-button"><img src="/plus.svg" /></button>
    </div>



    <div className="reaction-edit-content">
        <label htmlFor="englishName">Reactants</label>
        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="Acetoacetic Ester Synthesis" />
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg"/></button>
        </div>
        <hr/>

        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="アセト酢酸エステル合成" />
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button>
        </div>
        <hr/>

        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="" placeholder="サジェスチョンの単語を入力" />
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button>
        </div>
        <hr/>

        <button className="reaction-edit-multi-input-plus-button"><img src="/plus.svg" /></button>
    </div>


    <div className="reaction-edit-content">
        <label htmlFor="englishName">Products</label>
        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="Acetoacetic Ester Synthesis" />
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button>
        </div>
        <hr/>

        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="アセト酢酸エステル合成" />
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button>
        </div>
        <hr/>

        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="" placeholder="サジェスチョンの単語を入力" />
            <button className="reaction-edit-image-delete-button"><img src="/image-delete.svg" /></button>
        </div>
        <hr/>

        <button className="reaction-edit-multi-input-plus-button"><img src="/plus.svg" /></button>
    </div>



    <div className="reaction-edit-content">
        <label htmlFor="englishName">Youtube</label>
        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="Acetoacetic Ester Synthesis" />
            <button className="reaction-edit-image-delete-button"><img src="image/image-delete.svg" /></button>
        </div>
        <hr/>

        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="アセト酢酸エステル合成" />
            <button className="reaction-edit-image-delete-button"><img src="image/image-delete.svg" /></button>
        </div>
        <hr/>

        <div className="reaction-edit-multi-input-container">
            <input type="text" name="englishName" value="" placeholder="サジェスチョンの単語を入力" />
            <button className="reaction-edit-image-delete-button"><img src="image/image-delete.svg" /></button>
        </div>
        <hr/>

        <button className="reaction-edit-multi-input-plus-button"><img src="/plus.svg" /></button>

        <button className="reaction-edit-add-reaction-button"><img src="/add-reaction.svg" /></button>

    </div>

</form> 

</main>
    );
  }
  