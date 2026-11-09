"""Freeze the full-run evidence handoff from the study directory."""
import hashlib
import json
from pathlib import Path

import yaml

root = Path.cwd()
plan = yaml.safe_load(Path("REPLICATION-PLAN.yaml").read_text())
summary = json.loads(Path("results/full/comparison-summary.json").read_text())
source_id = "https://digitalcommons.unl.edu/cehsdiss/106/"
artifacts = {}

def artifact(path):
    path = str(path)
    if path not in artifacts:
        artifacts[path] = dict(id=path, path=path, sha256=hashlib.sha256(Path(path).read_bytes()).hexdigest())
    return path

meta = artifact("provenance/source-acquisition.json")
inventory = artifact("notes/claim-inventory.md")
artifact("source-inventory.json")
artifact("DISAGREEMENTS.yaml")
artifact("REPLICATION-PLAN.yaml")
artifact("rerun/README.md")
artifact("rerun/reproduce.sh")
for p in ("rerun/check_oversampling.py", "rerun/formulaic.R", "rerun/precision_demo.py",
          "scripts/model.R", "rerun/full_grid.R", "rerun/validate_profile.R"):
    artifact(p)
artifact("handoff/method-references.md")
artifact("notes/rerun-engine.json")
for path in sorted(Path("source-values").glob("*.csv")):
    artifact(path)
for path in sorted(Path("results").rglob("*")):
    if path.is_file():
        artifact(path)
        if "interim" in path.parts:
            artifacts[str(path)]["role"] = "historical_interim"
for path in ("results/source-identities.json", "outputs/baseline-diagnostic.csv",
             "outputs/table3-gap-summary.csv", "outputs/table3-independent-check.csv",
             "outputs/table3-allocation-summary.csv", "results/independent-engines.csv"):
    artifact(path)
parts = {p["id"]:p for p in plan["parts"]}
status = {"replicated":"replicated", "partly":"partly_replicated", "mismatch":"not_replicated"}
claims = {}
effects = []
conditions = ("Four occasions and 20 participants per cluster on average. The 54 cells cross ICC .05/.10/.15, "
              "interval dropout 0/5/15%, allocation 50/50 or 70/30, and equal, normal, or skewed cluster sizes.")
limits = [
    "For initial-empirical, appendix-a and appendix-b, the original software state, realized SAS streams and unit-level masks are unavailable.",
    "For initial-exemplary and empirical-gap, three plotted exemplary markers are occluded. The publication gives the full-grid sign count separately.",
    "For rq1, rq2, rq3, rq4, thresholds and oversample, the source exemplary estimates describe realized designs. Rerun estimates with dropout average independently sampled masks.",
    "For oversample, .88187 lies below the central rerun predictive interval. A rare-mask diagnostic shows feasibility without identifying the source mask.",
    "For null-extreme, the printed Optimal Design values differ under the labeled df. A smaller effective df is compatible with the reported rates, while its historical use is unknown.",
    "For precision and ch2, the toy seed states and the precise implementation of the original Optimal Design interface are unavailable.",
    "For practical-verdict, the four-occasion Gaussian model and the published dropout mechanism limit the scope of planning conclusions.",
    "For rq1 and oversample, the reported planning result uses all available occasions. A completers-only or listwise analysis is outside the evaluated design.",
    "For formula-bw, the observed-N extension to the reported complete-design equation is an implementation assumption.",
]
def claim(key, statement, published, ours, locator, extra=(), method=None):
    part = parts[key]
    refs = list(dict.fromkeys(artifact(p) for p in (meta, inventory, *part["evidence"].split("; "), *extra)))
    reason = part.get("reason", "The reconstructed analysis recovers the reported scientific result at the comparison scale stated.")
    a = dict(id=key, level="supporting", statement=statement, source_locator=locator, artifact_ids=refs,
             published=dict(value=published,units="reported finding"), ours=dict(value=ours,units="observed finding"),
             conditions=conditions, methods=method or part["plan"],
             uncertainty="See this claim's interpretation and the full result artifact. Original numerical and software uncertainty is only partially observable.",
             multiplicity="Point comparisons are descriptive. For grid tests, report the original comparison family's Bonferroni-adjusted bands.",
             status=status[part["status"]],status_reason=reason, numerical=ours,
             reconstruction_scope="Source-derived distributional reconstruction in R and independent arithmetic checks.",
             reproduction_deviation=reason, contrasts=[],
             contrast_not_applicable="The underlying comparison is recorded directly in the study artifacts.",
             limitations=[v for v in limits if key in v] or ["This comparison is conditional on the source model and reported design."],
             stopping=dict(reason=reason,attempted=part["plan"],
                           untested="The original executable state and random streams were not recovered.",
                           resource_basis="All planned main-grid draws, follow-up draws and reported design settings are accounted for.",
                           next_evidence="Original fitted records or random states would permit a direct implementation comparison."))
    claims[key]=a
    return a

def headline(key, statement, pub_text, our_text, locator, excerpt, source_file, result_file, contrasts):
    a=claim(key,statement,pub_text,our_text,locator,(source_file,result_file))
    a["level"]="headline"
    a["contrasts"]=[]
    a.pop("contrast_not_applicable")
    def findings(published, ours, excerpt, ids):
        return dict(
            published=dict(text=published,state="reported",artifact_ids=[source_file,meta],
                           locator=locator,page_locator=locator,source_excerpt=excerpt,
                           claim_type="numerical estimate",conditions=conditions,
                           component_claim_ids=[],component_contrast_indices=ids),
            ours=dict(text=ours,state="observed",artifact_ids=[result_file],locator=result_file,
                      component_claim_ids=[],component_contrast_indices=ids))
    a["findings"]=findings(pub_text,our_text,excerpt,list(range(len(contrasts))))
    for i,(ident,definition,unit,positive,p,o,rounding,ptext,otext) in enumerate(contrasts):
        tol,decimals,basis=rounding
        a["contrasts"].append(dict(definition=definition,units=unit,positive_means=positive,published=p,ours=o))
        magnitude="same" if abs(abs(o)-abs(p)) <= tol else ("larger" if abs(o)>abs(p) else "smaller")
        e=dict(id=ident,claim_id=key,contrast_index=i,estimand=definition,units=unit,positive_means=positive,
               published_effect=p,ours_effect=o,estimate_status="resolved",display_decimals=3 if unit=="pp" else 0,
               tolerance={"kind":"rounding","value":tol,"components":[dict(decimals=decimals,weight=tol/(.5*10**-decimals))],"basis":basis},
               magnitude=magnitude,direction="same direction",interpretation="descriptive point estimates; not equivalence",
               uncertainty_statement="The estimates describe the reconstructed design. Mask variation and figure reading error are considered separately.")
        if len(contrasts)>1 and i>0:
            row_excerpt = {
                "SS": "an average decline of 0.85% in the negatively skewed",
                "A15": "The decrease in power as a result of 15% attrition per interval",
            }.get(ident, excerpt)
            e["findings"]=findings(ptext,otext,row_excerpt,list(range(len(contrasts))))
        effects.append(e)

matches={(r["contrast"],r["icc"]):r for r in summary["contrast_summary"] if r["stage"]==1}
def loss(k, ident, name, pub, ours):
    d=matches[k,None]
    return (ident,name,"pp","the violation reduces power",d["published_pp"],d["ours_pp"],
            (.001,3,"Average of differences of Table 1 powers expressed in pp. Each input rounds to .001 pp and the two sets of absolute weights sum to two."),pub,ours)

P="results/full/paired-contrasts.csv"
T="source-values/table-1.csv"
headline("rq1","Interval attrition reduces power.","1.3 pp mean loss","1.27 pp mean loss",
         "pp. 93–94, Tables 1–2","with an average of 1.3%",T,P,[
          loss("attrition-5","A5","5% dropout","1.3 pp mean loss","1.27 pp mean loss"),
          loss("attrition-15","A15","15% dropout","15% dropout reduces power","15% dropout reduces power")])
headline("rq2","Allocation imbalance reduces power.","6.4 pp mean loss","6.44 pp mean loss",
         "p. 95, Table 1","with an average decline of 6.4%",T,P,[
          loss("allocation","A70","70/30 allocation","6.4 pp mean loss","6.44 pp mean loss")])
headline("rq3","Unequal sizes produce smaller power losses than other violations.","0.45 pp mean loss","0.44 pp mean loss",
         "pp. 95–96, Table 1","an average decline of 0.45% in the normally distributed condition",T,P,[
          loss("normal-size","SN","Normal sizes","0.45 pp mean loss","0.44 pp mean loss"),
          loss("skewed-size","SS","Skewed sizes","0.85 pp mean loss","0.78 pp mean loss")])
p=matches["attrition-15",.05]["published_pp"]-matches["attrition-15",.15]["published_pp"]
o=matches["attrition-15",.05]["ours_pp"]-matches["attrition-15",.15]["ours_pp"]
headline("rq4","The tested losses are greatest at ICC .05, with a nonmonotonic skewed-size exception.",
         "All five losses peak at .05","All five losses peak at .05","p. 96, Tables 1 and 4",
         "higher losses in power were seen at the lowest level of ICC",T,"results/full/comparison-summary.json",[
          ("ICC","ICC .05 vs .15 at 15% dropout","pp","dropout loss is greater at ICC .05",p,o,
           (.002,3,"Difference of two mean power losses, each with a .001 pp bound from Table 1 rounding."),"","")])
headline("thresholds","The planning penalty can be several clusters.","Up to 8 extra clusters","Up to 7 extra clusters",
         "pp. 97–98, Table 5","The increases in the number of clusters range from zero to eight",
         "source-values/table-5.csv","results/full/threshold-comparison.csv",[
          ("J","Maximum extra clusters","clusters","more clusters are needed than in the reference",8,7,
           (.5,0,"Half the printed integer unit for the reported maximum extra count."),"","")])
headline("empirical-gap","Empirical power is below initial exemplary power in most cells.","41 of 54 below","40 of 54 below",
         "pp. 106–107","The empirical estimates were below exemplary estimates in 41 of the 54",
         "source-values/figures-6-11.csv","results/full/empirical-exemplary-gaps.csv",[
          ("G","Count below minus 27","cells","a majority of empirical estimates are lower",14,13,
           (.5,0,"Half the printed integer unit for the reported count. Subtraction of the exact majority baseline adds no uncertainty."),"","")])

support = [
 ("ch1","The three methods address a planning problem.","Longitudinal cluster power with violations","The same three methods were examined","pp. 1–6"),
 ("ch2","Closed-form example and software comparisons.","G*Power .584382; Optimal Design .550898 and .422156","G*Power .584382; formula .553630 and .425064","pp. 7–58, Figures 2–3"),
 ("precision","Monte Carlo precision depends on draw count.","25,600 and 102,400 draws for full widths .01 and .005","Both counts follow from binomial variance at power .80. The independent single-predictor illustration calibrates population power to .80 at n=75. The source power curve is unknown.","pp. 59–64, Figure 4"),
 ("ch3","The design crosses four factors.","54 initial settings and four occasions","All settings represented. Empirical unequal sizes are freshly drawn, rounded and truncated, with the specified skew adjustment. The exemplary grid uses the printed frequency schedules.","pp. 68–83, Figure 5 and Appendices A–B"),
 ("initial-empirical","Empirical power across the initial grid.","54 plotted empirical powers, 25,600 draws per cell","54 of 54 within adjusted comparison bands; 1,382,400 successful fits","pp. 84–89, Figures 6–8"),
 ("initial-exemplary","Known-covariance power across the initial grid.","54 initial exemplary values in Figures 6–8","54 reconstructed; all 51 readable points agree under adjusted bands","pp. 87–90"),
 ("final-exemplary","Known-covariance power near 80 percent at reference settings.","54 values at 13, 19 and 25 clusters","54 reconstructed; 18 deterministic cells match to five decimals","pp. 90–93, Table 1"),
 ("formula-od","The Optimal Design denominator is J minus two.","Even balanced thresholds 16, 22 and 28","Same even thresholds; allowing odd J gives 16, 21 and 27","pp. 83–89"),
 ("formula-bw","Between–within degrees of freedom raise reference power.","Initial baseline df=1262 and power about .88","Initial baseline power .877206; formula crossing at 13, 19 and 25 clusters","pp. 85–86, 97 and 103–104"),
 ("ch4","Source results combine figures, exemplary tables and thresholds.","Initial and final power, oversampling and thresholds","Full grid agrees within the adjusted comparison bands. Threshold and oversampling differences persist.","pp. 84–98"),
 ("oversample","Increasing clusters for dropout raises power above the target.","Table 3 range .83961 to .90204, including .88187 at 19 clusters","Six participant-loss means .83938 to .90192. At 19 clusters .88491 with central mask interval .88369 to .88569. The prose-only observation-loss heuristic gives .81179–.85463 using either nearest or upward rounding.","pp. 94–95 and 99–100, Table 3 and prose-only observation-loss heuristic"),
 ("hypothesis-order","The proposed hypothesis predicts that attrition is largest.","The hypothesis places attrition first","The published and R results both put 70/30 allocation first on average","p. 67 and Table 1"),
 ("ch5","The discussion draws planning and denominator-rule conclusions.","Empirical gap and two Appendix D scenarios","Planning result recurs for available-observation analyses. Extreme Optimal Design power and Type I error differ. The source completers example gives 230, yielding 195.5 expected completers. A target expectation of 200 at 15% loss requires 236.","pp. 99–112"),
 ("baseline-50000","The longer baseline run still gives lower empirical power.","Reported deficit about 0.9 pp","Deficit 0.879 pp after 50,000 draws; paired diagnostic supports a variance-refitting contribution","pp. 106–107"),
 ("appendix-a","The SAS code specifies the empirical generator and fit.","RANNOR(0), RANUNI(0), SAS PROC MIXED","Seed-state replay unavailable; independent generator and fit checks agree","pp. 124–126, Appendix A"),
 ("appendix-b","The exemplary implementation uses printed frequency arrays.","Normal and skew frequency arrays and independent random effects","Independent covariance implementations agree. Original masks unavailable.","pp. 127–129, Appendix B"),
 ("appendix-c","The fitted means track population values.","324 reported means, four isolated lost draws","All 324 means within adjusted diagnostic bands; no failed rerun fits","pp. 130–132, Appendix C"),
 ("null-baseline","Baseline Type I error depends on denominator rule.","Between–within .06839; Kenward–Roger .05021","Between–within .06500; containment .0648828; Kenward–Roger .04625, or .04891 dropping zero variance components. The original between–within and containment estimates exceed Serlin’s .065 endpoint. The reconstructed point estimates are on or inside it.","pp. 105 and 133, Table D.1"),
 ("null-extreme","Extreme-setting denominator rules yield different rejection rates.","Optimal Design power .67128 and Type I error .04279","At df=26, power .69594 and Type I error .04969. At df=15, .66953 and .04270.","p. 133, Table D.2"),
 ("practical-verdict","Attrition and treatment imbalance matter more than unequal cluster sizes.","Allocation and attrition dominate unequal sizes within the investigated design","Same planning ordering and 51 exact thresholds. Three mean-power thresholds occur one cluster earlier.","pp. 99–112"),
]
for row in support:
    claim(*row)
sections = [
 ("chapter-1","pp. 1–6",["ch1"]),
 ("chapter-2","pp. 7–67",["ch2","precision","hypothesis-order"]),
 ("chapter-3","pp. 68–83",["ch3","formula-od","formula-bw"]),
 ("chapter-4","pp. 84–98",["ch4","initial-empirical","initial-exemplary","final-exemplary","rq1","rq2","rq3","rq4","oversample","thresholds"]),
 ("chapter-5","pp. 99–112",["ch5","baseline-50000","empirical-gap","practical-verdict","null-baseline","null-extreme"]),
 ("appendix-a","pp. 124–126",["appendix-a"]),
 ("appendix-b","pp. 127–129",["appendix-b"]),
 ("appendix-c","pp. 130–132",["appendix-c"]),
 ("appendix-d","p. 133",["null-baseline","null-extreme"]),
]
packet=dict(schema_version=1,scope="whole_dissertation",dissertation=plan["dissertation"]+" "+source_id,
    replicated_work=dict(kind="dissertation",authors="Kevin A. Kupzyk",year="2011",
       title="The Effects of Simplifying Assumptions in Power Analysis",
       institution_or_venue="University of Nebraska–Lincoln",identifier=source_id,
       verification_locator="Official source and title page of the verified 143-page archival copy",artifact_ids=[meta]),
    synthesis=("Partly replicated. All 54 initial empirical power estimates fit the adjusted bands and the planning ordering recurs. "
      "Three exact cluster thresholds, the Table 3 tail cell, and an extreme Appendix D result differ. "
      "The primary source is held locally and verified by SHA-256. Its copyrighted PDF is excluded from Git."),
    artifacts=list(artifacts.values()),claims=list(claims.values()),headline_order=[k for k,c in claims.items() if c["level"]=="headline"],
    headline_effects=effects,limitations=limits,
    sections=[dict(id=i,locator=l,claim_ids=c) for i,l,c in sections]+[
       dict(id="references",locator="pp. 113–123",claim_ids=[],exclusion_reason="Bibliography only")],
    inventory_audit=dict(reviewer="Codex research pass",source_artifact_ids=[meta,inventory,"source-inventory.json"],
       rationale="Read the title, all five chapters and four appendices. Reconciled the four research questions, all tabular results, all plotted series, and the toy precision example to the chapter inventory."))
Path("evidence-packet.json").write_text(json.dumps(packet,indent=2,ensure_ascii=False)+"\n")
