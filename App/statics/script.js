document.getElementById("pollForm").addEventListener("submit", async (e) => {
  e.preventDefault();
  const choice = document.querySelector('input[name="vote"]:checked');
  if (!choice) return alert("Please select an option!");

  const resp = await fetch("/vote", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ choice: choice.value })
  });
  if (!resp.ok) return alert("Vote failed");

  await renderResults();
});

async function renderResults() {
  const r = await fetch("/results");
  const data = await r.json();
  const max = Math.max(...Object.values(data), 1);
  const resultsDiv = document.getElementById("results");
  resultsDiv.innerHTML = "";
  Object.entries(data).forEach(([k, v]) => {
    const bar = document.createElement("div");
    bar.className = "bar";
    bar.style.width = (v / max) * 100 + "%";
    bar.textContent = `${k} (${v})`;
    resultsDiv.appendChild(bar);
  });
}

renderResults().catch(() => {});
