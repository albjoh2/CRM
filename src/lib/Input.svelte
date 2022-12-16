<script>
    import InputItem from "./InputItem.svelte";
    let articles = [];
    let inputValueArticle = "";

    for(let i = 0; i < localStorage.length; i++){
        let key = localStorage.key(i);
        if(key.startsWith("article")){
            let article = JSON.parse(localStorage.getItem(key));
            articles.push(article);
        }
    }

    let filteredArticles = []

    function filterArticles(){
        let storageArray = [];
        if(inputValueArticle){
            articles.forEach(article => {
                if(article.name.toLowerCase().includes(inputValueArticle.toLowerCase()) || article.id.toString().includes(inputValueArticle)){
                    storageArray = [...storageArray, makeMatchBold(article.id.toString() + " " + article.name)];
                }
            })
        }else{
            filteredArticles = []
        }
        filteredArticles = storageArray;
    }

    function makeMatchBold(str){
        let index = str.toString().toLowerCase().indexOf(inputValueArticle.toLowerCase())
        let firstPart = str.slice(0, index)
        let secondPart = str.slice(index + inputValueArticle.length)
        return firstPart + "<strong>" + inputValueArticle + "</strong>" + secondPart
    }

    let highlightedIndex = -1;

    const navigateList = (e) => {
        if(e.key === "ArrowDown"){
            e.preventDefault();
            if(highlightedIndex < filteredArticles.length - 1){
                highlightedIndex++;
            }
        }else if(e.key === "ArrowUp"){
            e.preventDefault();
            if(highlightedIndex > 0){
                highlightedIndex--;
            }
        }else if(e.key === "Enter"){
            e.preventDefault();
            if(highlightedIndex > -1){
                inputValueArticle = filteredArticles[highlightedIndex].replace("<strong>", "").replace("</strong>", "");
                filteredArticles = [];
                highlightedIndex = -1;
            }
        }
    }
    let articleDoNotExist = true;

$: inputValueArticle && checkIfArticleExist();

function checkIfArticleExist(event){
    if(event){
        inputValueArticle = event.currentTarget.innerText
    }
    articleDoNotExist = true;
    articles.forEach(article => {
        if(article.id.toString() + " " + article.name.toLowerCase() === inputValueArticle.toLowerCase()){
            articleDoNotExist = false;
        }
    })
}

</script>

<svelte:window on:keydown={navigateList} />

<form autocomplete="off">
    <div class="autocomplete">
      <input id="myInput" class:wrongArticle={articleDoNotExist} on:blur={()=>{checkIfArticleExist()}} class="art" type="text" bind:value={inputValueArticle} name="article" placeholder="Article" on:input on:input={filterArticles}>
      <ul class="autocomplete-items-cont">
          {#each filteredArticles as article, i}
              <InputItem on:click highlighted={i === highlightedIndex} on:click={()=>{
                checkIfArticleExist(event)
                filteredArticles = []}} listItemText={article}/>
          {/each}
      </ul>
    </div>
</form>

  <style>
    .wrongArticle{
        border: 1px solid red;
    }
    .autocomplete {
        position: relative;
        display: inline-block;
    }
    .autocomplete-items-cont{
        position: absolute;
        border: 1px solid #d4d4d4;
        border-bottom: none;
        border-top: none;
        z-index: 99;
        top: 100%;
        left: 0;
        right: 0;
    }
    input {
        border: 1px solid transparent;
        background-color: #f1f1f1;
        padding: 10px;
        font-size: 16px;
    }
    input[type=text] {
        background-color: #f1f1f1;
        width: 100%;
    }


  </style>