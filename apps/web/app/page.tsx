export default function Home() {
  return (
    <main className="page">
      <section className="hero">
        <p className="eyebrow">Diarlies</p>
        <h1>AI that listens to your day and writes the diary for you.</h1>
        <p className="lede">
          Talk about what happened, track habits, and get thoughtful entries
          crafted automatically.
        </p>
        <div className="cta-row">
          <button className="btn primary">Start a diary</button>
          <button className="btn ghost">View API</button>
        </div>
      </section>

      <section className="grid">
        <article>
          <h3>Voice-first</h3>
          <p>Capture moments by speaking; the web app transcribes and structures them.</p>
        </article>
        <article>
          <h3>Behavior insights</h3>
          <p>Track routines and mood trends to give each entry richer context.</p>
        </article>
        <article>
          <h3>Safe by design</h3>
          <p>Your data stays yours; backing services are built with privacy in mind.</p>
        </article>
      </section>
    </main>
  );
}
