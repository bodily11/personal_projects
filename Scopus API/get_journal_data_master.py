journals = [
    ['Journal example name','ISSN from Scopus'],
    ['Journal example 2','ISSN get from Scopus']
]

import urllib
import json
import requests as r
import pandas as pd
import numpy as np
import math

#insert API key below
api_key = ''
journalData = []

for journal_object in journals:
    journal_name = journal_object[0]
    ISSN = journal_object[1]

    articles = []

    #get first page of search result
    #if ESSN is in the ISSN we need to search by EISSN instead.
    if 'EISSN' in ISSN:
        source_title = urllib.quote_plus(ISSN.split(': ')[1])
        request_url = 'https://api.elsevier.com/content/search/scopus?query=EISSN({})&apiKey={}&view=COMPLETE'.format(source_title,api_key)
    else:
        source_title = urllib.quote_plus(ISSN)
        request_url = 'https://api.elsevier.com/content/search/scopus?query=ISSN({})&apiKey={}&view=COMPLETE'.format(source_title,api_key)

    response = r.get(request_url)
    json_data = json.loads(response.text)

    #add all of the articles retrieved to the articles list
    articles = articles + json_data['search-results']['entry']

    #calculate the number of iterations needed by dividing the number of total results by 25 and rounding down
    number_of_iterations = int(math.floor(int(json_data['search-results']['opensearch:totalResults'])/25.))

    #how many total iterations
    print number_of_iterations

    #if we retrieved all results, go to the next journal
    if number_of_iterations == 0:
        continue

    #return the next result for the number of iterations specified
    for x in range(number_of_iterations):
        for y in json_data['search-results']['link']:
            if y['@ref'] == 'next':
                response = r.get(y['@href'])
                json_data = json.loads(response.text)

                #add the articles to the previously added articles
                articles = articles + json_data['search-results']['entry']

    #this loops through all articles and flattens the JSON data into a flat file to import to Pandas
    new_articles = []

    #these are all of the top level fields I can loop through to add
    fields = [('abstract','dc:description'),('citedBy','citedby-count'),('scopusID','dc:identifier'),
              ('authorKeywords','authkeywords'),('title','dc:title'),('scopusEID','eid'),
              ('publicationVenue','prism:aggregationType'),('coverDate','prism:coverDate'),('year','prism:coverDisplayDate'),
              ('issueNumber','prism:issueIdentifier'),('pageRange','prism:pageRange'),('publicationName','prism:publicationName'),
              ('URL','prism:url'),('doi','prism:doi'),('volumeNumber','prism:volume'),
              ('sourceID','source-id'),('articleTypeAbbr','subtype'),('articleType','subtypeDescription')]

    for article in articles:
        current_article = {}
        for field in fields:
            if field[1] in article:
                current_article[field[0]] = article[field[1]]
            else:
                pass
        save_current_article = dict(current_article)
        if 'author' in article:
            for author in article['author']:
                current_article = dict(save_current_article)
                current_article['author_num'] = author['@seq']
                current_article['author_afid'] = author['afid'][0]['$'] if 'afid' in author else None
                current_article['authname'] = author['authname']
                current_article['auth_id'] = author['authid']

                if 'affiliation' in article:
                    for x in article['affiliation']:
                        if current_article['author_afid'] == x['afid']:
                            current_article['city'] = x['affiliation-city']
                            current_article['country'] = x['affiliation-country']
                            current_article['university'] = x['affilname']
                            current_article['affil_afid'] = x['afid']
                new_articles.append(current_article)

    df = pd.DataFrame(new_articles)

    def extract_year(cell):
        import re
        try:
            return re.search(r'[12]\d{3}', cell).group(0)
        except:
            return None

    df['year'] = df.year.map(extract_year)
    df.to_csv('{}_{}.csv'.format(project,journal_name),encoding='utf-8',index=False)


for journal_object in journals:
    journal_name = journal_object[0]
    ISSN = journal_object[1]
    #for this request it doesn't matter if I use an EISSN or an ISSN
    if 'EISSN' in ISSN:
        ISSN = ISSN.split(': ')[1]

    #url encode the ISSN
    source_title = urllib.quote_plus(ISSN)

    request_url = 'http://api.elsevier.com/content/serial/title/issn/{}?apiKey={}&view=Enhanced'.format(source_title,api_key)
    response = r.get(request_url)
    print(response.text)
    try:
        json_data = json.loads(response.text)
    except:
        print journal_name,ISSN,'no JSON object could be decoded, possible ISSN error'
        continue
    print(json_data.keys())
    if 'serial-metadata-response' in json_data:
        jd = json_data['serial-metadata-response']['entry'][0]
    else:
        print('no journal metrics data found for the below journal')
        print(journal_name)
        continue

    #try to figure out if IPP is being returned with an enhanced view request


    ###FLATTEN DATA DOWN###

    if 'SJRList' in jd:
        SJR = jd['SJRList']['SJR'][0]['$']
        SJR_year = jd['SJRList']['SJR'][0]['@year']
    else:
        SJR = None
        SJR_year = None

    if 'SNIPList' in jd:
        SNIP = jd['SNIPList']['SNIP'][0]['$']
        SNIP_year = jd['SNIPList']['SNIP'][0]['@year']
    else:
        SNIP = None
        SNIP_year = None

    if 'citeScoreYearInfoList' in jd:
        citeScoreCurrentMetric = jd['citeScoreYearInfoList']['citeScoreCurrentMetric']
        citeScoreCurrentMetricYear = jd['citeScoreYearInfoList']['citeScoreCurrentMetricYear']

    else:
        citeScoreCurrentMetric = None
        citeScoreCurrentMetricYear = None

    if 'dc:publisher' in jd:
        publisher = jd['dc:publisher']
    else:
        publisher = None

    if 'dc:title' in jd:
        journal_title = jd['dc:title']
    else:
        journal_title = None

    cover_image_link = None
    for link in jd['link']:
        if link['@ref'] == 'coverimage':
            cover_image_link = link['@href']

    oaAllowsAuthorPaid = jd['oaAllowsAuthorPaid']
    openArchiveArticle = jd['openArchiveArticle']
    openaccessStartDate = jd['openaccessStartDate']
    openaccessType = jd['openaccessType']
    aggregationType = jd['prism:aggregationType']

    if 'prism:url' in jd:
        URL = jd['prism:url']
    else:
        URL = None

    if 'source-id' in jd:
        sourceID = jd['source-id']
    else:
        sourceID = None

    subjectNames = []
    subjectAbbrevs = []
    subjectCodes = []
    if 'subject-area' in jd:
        for subject in jd['subject-area']:
            subjectName = subject['$']
            subjectNames.append(subjectName)

            subjectAbbrev = subject['@abbrev']
            subjectAbbrevs.append(subjectAbbrev)

            subjectCode = subject['@code']
            subjectCodes.append(subjectCode)
    else:
        subjectAreas = None

    thisJournal = {'SJR':SJR,
            'SJR_year':SJR_year,
            'SNIP':SNIP,
            'SNIP_year':SNIP_year,
            'citeScoreCurrentMetric':citeScoreCurrentMetric,
            'citeScoreCurrentMetricYear':citeScoreCurrentMetricYear,
            'publisher':publisher,
            'journal_title':journal_title,
            'cover_image_link':cover_image_link,
            'oaAllowsAuthorPaid':oaAllowsAuthorPaid,
            'openArchiveArticle':openArchiveArticle,
            'openaccessStartDate':openaccessStartDate,
            'openaccessType':openaccessType,
            'aggregationType':aggregationType,
            'ISSN':ISSN,
            'URL':URL,
            'sourceID':sourceID,
            'subjectNames':subjectNames,
            'subjectAbbrevs':subjectAbbrevs,
            'subjectCodes':subjectCodes,
                  }

    if 'yearly-data' in jd:
        if jd['yearly-data'] != None:
            for years in jd['yearly-data']['info']:
                yearly_data_fields = ['citeCountSCE','zeroCitesPercentSCE','@year','publicationCount','revPercent','zeroCitesSCE']
                year = years['@year']
                for field in yearly_data_fields:
                    thisJournal[year+field] = years[field]
    else:
        yearlyData = None

    journalData.append(thisJournal)


df = pd.DataFrame(journalData)
df.to_csv('{}_journal_metric_data.csv'.format(project),encoding='utf-8',index=False)
