# Author pronouns

Formal text refers to an author by surname. A pronoun is for a later sentence
in the same passage. The ordinary form is the surname again when this lookup
declines a pronoun.

A pronoun the author states in a biography, a profile, or the paper is the
pronoun the note uses. That statement is read before the table. The table
applies when no such statement was found.

## Source

Use the World Gender Name Dictionary, version 2.0 (WGND 2.0).

- Dataset: Raffo, Julio, 2021, "WGND 2.0", Harvard Dataverse, V1,
  [doi:10.7910/DVN/MSEGSJ](https://doi.org/10.7910/DVN/MSEGSJ). The files used
  here are dataset version 1.1. License: [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
- Method: Gema Lax Martínez, Helena Saenz de Juano-i-Ribes, Deyun Yin, Bruno
  Le Feuvre, Intan Hamdan-Livramento, Kaori Saito, and Julio Raffo, *Expanding
  the World Gender-Name Dictionary: WGND 2.0*, WIPO Economic Research Working
  Paper No. 64, 2021,
  [wipo.int/publications/en/details.jsp?id=4554](https://www.wipo.int/publications/en/details.jsp?id=4554).
- The 2021 paper revises Lax Martínez, Raffo, and Saito, *Identifying the
  Gender of PCT Inventors*, WIPO Economic Research Working Paper No. 33, 2016,
  [wipo.int/publications/en/details.jsp?id=4125](https://www.wipo.int/publications/en/details.jsp?id=4125).

The dictionary links a given name, an ISO 3166-1 alpha-2 country code, and a
gender code. `F` is the dictionary's feminine name, `M` its masculine name,
and `?` unknown or unisex. `wgt` is the proportion of recorded frequencies for
that name, country, and code. The proportions for one name and country sum to
1. In the sources file, `nobs` is the recorded count and `src` names the
collection. `US_gov` is the US Social Security Administration list.
`CN_web` and `INT_web` are web compilations, and a count of 1 there is a
listing.

WGND 2.0 is the source because it is free, CC0, downloadable, citable by a
DOI, and it gives a weight for each country. The name-gender-code file has
4,970,296 name-country-gender rows and 195 countries, including a China
section of about 1.2 million names (Lax Martínez et al. 2021, Figure 3). The
other candidates do not meet that combination:

| Source | Why it is not the lookup |
| --- | --- |
| US Social Security Administration baby names | Public-domain US birth counts. No country field, so it cannot answer a China query. |
| R `gender` package (Mullen), with SSA and IPUMS | US historical counts. The method is Blevins and Mullen, "Jane, John ... Leslie? A Historical Method for Algorithmic Gender Prediction," *Digital Humanities Quarterly* 9, no. 3 (2015). |
| Wikidata name lists | CC0 records about people, not a country-frequency table with a dataset DOI. |
| genderize.io | Proprietary API. On 27 October 2026, `api.genderize.io?name=xiaojuan&country_id=CN` returned female, probability 1, count 203. The terms keep the dataset with Demografix and forbid rebuilding it. No DOI. |
| Gender API | Paid API. No open file and no dataset DOI. |

## Lookup

1. Identify the given name. In a Chinese name written family-name first, the
   given name is the second element. Look up the given name. Leave the surname
   out of the query.
2. Use the country of origin when it is known. `CN` is China. `CH` is
   Switzerland. A row from another country is not a substitute.
3. Read `wgt` in `wgnd_2_0_name-gender-code` for that given name and country.
   The script spaces a concatenated pinyin string, such as `Xiaojuan`, only
   when that exact string has no row for the country. It keeps the exact
   spelling when a row exists. It does not average a second spelling into the
   weight.
4. A gendered pronoun is available when one of `F` or `M` has weight at least
   0.9 and the largest `nobs` for that gender, name, and country is at least
   30. `F` corresponds to she/her. `M` corresponds to he/him. The unknown code
   supplies no pronoun.
5. Thirty is this repository's minimum count. For a name recorded entirely as
   one gender, a one-sided 95 percent lower bound on the proportion reaches
   about 0.905 at 30 records (`0.05^(1/30)`). A weight of 1 on a single web
   listing is a label. Both numbers are this repository's rule. The WIPO paper
   defines the weight and the count; it does not set 0.9 or 30.
6. Below either bar, repeat the surname. They is the pronoun when the author
   states it.

The China section is a web compilation. Two characters can share one pinyin
spelling, so a China weight of 1 with a count of 1 stays below the count bar.

## Citation

Cite the dataset and the 2021 working paper in a note when a pronoun comes
from the table. A paper that uses only surnames can omit the citation.

> Pronouns follow WGND 2.0 for the author's country of origin when one gender
> has weight at least 0.9 and the largest source count for that gender is at
> least 30 (Raffo 2021; Lax Martínez et al. 2021). Otherwise the author is
> referred to by surname. A pronoun stated by the author takes precedence.

```bibtex
@data{raffo2021wgnd,
  author    = {Raffo, Julio},
  title     = {{WGND} 2.0},
  year      = {2021},
  publisher = {Harvard Dataverse},
  version   = {V1},
  doi       = {10.7910/DVN/MSEGSJ},
  url       = {https://doi.org/10.7910/DVN/MSEGSJ}
}
@techreport{laxmartinez2021wgnd,
  author      = {Lax Mart{\'i}nez, Gema and Saenz de Juano-i-Ribes, Helena
                 and Yin, Deyun and Le Feuvre, Bruno
                 and Hamdan-Livramento, Intan and Saito, Kaori and Raffo, Julio},
  title       = {Expanding the World Gender-Name Dictionary: {WGND} 2.0},
  type        = {Economic Research Working Paper},
  number      = {64},
  institution = {World Intellectual Property Organization},
  year        = {2021},
  url         = {https://www.wipo.int/publications/en/details.jsp?id=4554}
}
```

## Script

The full CSVs are not in git. From the repository root:

```sh
python3 .agents/skills/replication-paper/scripts/wgnd_lookup.py --download /tmp/wgnd
python3 .agents/skills/replication-paper/scripts/wgnd_lookup.py \
  --data /tmp/wgnd/wgnd_2_0_name-gender-code.csv \
  --sources /tmp/wgnd/wgnd_2_0_sources.csv \
  --country CN \
  Xiaojuan
```

`--download` resolves the files from the dataset DOI and checks the original
CSVs:

| File | MD5 | Bytes |
| --- | --- | --- |
| `wgnd_2_0_name-gender-code.csv` | `c35e61bddfa2841fb89aa793dcd9b9f9` | 91229769 |
| `wgnd_2_0_sources.csv` | `dca1a4548196fed0c597f63a4a64dc38` | 137854765 |

Those sums matched the Dataverse originals on 27 October 2026. The fixture
check does not need the download:

```sh
python3 .agents/skills/replication-paper/scripts/wgnd_lookup.py --self-check
```

`scripts/testdata/` holds the CC0 rows for that check. It is an extract, not
the dictionary.

## Checked names

Read from the original CSVs on 27 October 2026.

| Given name | Country | Form used | Weights | Largest count | Pronoun |
| --- | --- | --- | --- | --- | --- |
| Xiaojuan | CN | `xiao juan` (the exact token `xiaojuan` has no China row) | F .47200927, M .027990742, ? .5 | F 1 (`CN_web`), M 1 (`CN_web`), ? 1 (`INT_web`) | none |
| Xiaojuan | ES | `xiaojuan` | F 1 | F 90 (`ES_gov`) | she/her |
| Xiaojuan | CH | `xiaojuan` | F 1 | F 7 (`CH_gov`) | none |
| Xiaoyan | CN | `xiaoyan` | F 1 | F 1 (`INT_web`) | none |
| Elizabeth | US | `elizabeth` | F .99676567, M .0032343455 | F 1581894 (`US_gov`) | she/her |
| Andrea | US | `andrea` | F .98641098, M .013589008 | F 418188 (`US_gov`) | she/her |
| Andrea | IT | `andrea` | M 1 | M 1 (`INT_web`) | none |
| Priya | IN | `priya` | F .75, ? .25 | F 1 | none |
| Haruki | JP | `haruki` | F .16666667, M .83333331 | M 1 | none |

The China query for Xiaojuan also sees the separate spelling `xiao-juan`,
whose only China row is unknown with weight 1. The script reports that
spelling. The weight it uses is the spaced form alone.

Spain's count of 90 is the Spanish statistical office's count of the given
name Xiaojuan. That pronoun applies when the country of origin is Spain.
The China result is the first row.
