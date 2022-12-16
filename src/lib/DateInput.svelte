<script context="module">
    export function iso(date) {
      const pad = n => n < 10 ? "0" + n : n;
      return date.getFullYear() + "-" + pad(date.getMonth()+1) + "-" + pad(date.getDate());
    }
</script>
  
<script>
    export let value = iso(new Date());
    export let days = 'Mo|Tu|We|Th|Fr|Sa|Su'.split('|');
    export let months = 'Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec'.split('|');
    export let start = 0; // first day of the week (0 = Sunday, 1 = Monday)
    export let offset = 0; // offset in months from currently selected date
    
    let date = iso(new Date());
    
    $: acceptDate(value);
    
    function acceptDate(value) {
      const newDate = new Date(value);
      
      // @ts-ignore
      if (!isNaN(newDate)) {
        date = iso(newDate);
      }
    }
    
    function go(direction) {
      offset = offset + direction;
    }
    
    function selectDate(newValue) {
    if(newValue < iso(new Date())){
        alert("You can't select a date in the past");
        newValue = iso(new Date())
    }
      date = newValue;
      value = newValue;
      offset = 0;
    }
    
    $: viewDate = viewDateFrom(date, offset);
    
    $: month = months[viewDate.getMonth()];
    
    $: year = viewDate.getFullYear();
    
    $: weeks = weeksFrom(viewDate, date, start);
    
    function viewDateFrom(date, offset) {
      var viewDate = new Date(date);
      viewDate.setMonth(viewDate.getMonth() + offset);
      return viewDate;
    }
  
    function weeksFrom(viewDate, date, start) {
      var first = new Date(viewDate.getTime());
      first.setDate(1);
      first.setDate(first.getDate() + ((start - first.getDay() - 7) % 7));
  
      var last = new Date(viewDate.getTime());
      last.setDate(new Date(viewDate.getFullYear(), viewDate.getMonth() + 1, 0).getDate());
      last.setDate(last.getDate() + ((start - last.getDay() + 6) % 7));
  
      var d = new Date(first.getTime()),
          M = viewDate.getMonth(),
          Y = viewDate.getFullYear(),
          week = [],
          weeks = [week];
  
      while (d.getTime() <= last.getTime()) {
        var dd = d.getDate(),
            mm = d.getMonth(),
            yy = d.getFullYear(),
            value = iso(d);
  
        week.push({
          date: dd,
          value,
          class: [
            date === value ? "selected" : "",
            mm == M ? "" : ((mm > M ? yy >= Y : yy > Y) ? "future" : "past")
          ].join(' ')
        });
  
        d = new Date(d.getFullYear(), d.getMonth(), d.getDate() + 1);
  
        if (d.getDay() === start) {
          week = [];
          weeks.push(week);
        }
      }
  
      return weeks;
    }
  </script>
  
  <table>
    <tr>
      <td class="btn" on:keydown={() => go(-1)} on:click={() => go(-1)}>&#9664;</td>
      <td class="th" colspan=5>{month} {year}</td>
      <td class="btn" on:keydown={() => go(-1)} on:click={() => go(+1)}>&#9654;</td>
    </tr>
    <tr>
      {#each days as day}
      <th>{day}</th>
      {/each}
    </tr>
    {#each weeks as week}
    <tr on:click>
      {#each week as day}
      <td class="days btn {day.class}" on:keydown={() => go(-1)} on:click={() => selectDate(day.value)}>{day.date}</td>
      {/each}
    </tr>
    {/each}
  </table>
  
  <style>
    .th{
      text-align: center;
      width: 60px;
    }
    table {
        position: absolute;
        top:100%;
        border-collapse: collapse;
        border-spacing: 0;
        font-size: 0.8em;
        display: flex;
        flex-direction: column;
        align-items: center;
        border: #cccccc 1px solid;
        background-color: #eeeeee;
        border-radius: 5px;
        padding: 0px;
    }
    td, th {
        width: 32.3px;
        text-align: center;
        border-radius: 4px;
        line-height: 24px;
        margin: 0;
        padding: 0;
    }
    td.past, td.future {
        opacity: 0.5;
    }
    .btn {
        cursor: pointer;
    }
    .days {
        border: #cccccc 0.5px solid;
    }
    .btn:hover {
        background: gray;
        color: white;
    }
    td.selected {
        color: #ffffff;
        font-weight: bold;
        background-color: #006dcc;
        border-color: #002a80;
    }
  </style>