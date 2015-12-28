namespace :upi do
  desc "Creates the UPI fields. Parameters: TOURNAMENT"
  task :create => :environment do
    tournament_id = ENV['TOURNAMENT'] || 'no-borders'
    tournament = Tournament.friendly.find(tournament_id)

    tournament.fields.create!(
      name: 'UPI1',
      lat: 45.2456681689589, long: -75.6163644790649,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61704058530103, 45.24560112337739],
            [-75.61682149825708, 45.24531101502135],
            [-75.61568837209097, 45.24573520582302],
            [-75.61590746188978, 45.2460253137602],
            [-75.61704058530103, 45.24560112337739]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI2',
      lat: 45.2464348779974, long: -75.6154149770737,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61529621619593, 45.245961481837725],
            [-75.61489206463057, 45.24612576502422],
            [-75.6155337502613, 45.246908270393234],
            [-75.61593790622516, 45.246743985781386],
            [-75.61529621619593, 45.245961481837725]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI3',
      lat: 45.2466048367279, long: -75.6149965524673,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61487779123428, 45.24613144056821],
            [-75.61447363845969, 45.24629572375469],
            [-75.61511532601037, 45.24707822912369],
            [-75.61551948318345, 45.246913944511846],
            [-75.61487779123428, 45.24613144056821]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI4',
      lat: 45.2468050096916, long: -75.6144922971725,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61437353552094, 45.2463316135319],
            [-75.61396938132219, 45.24649589671837],
            [-75.61461107113416, 45.24727840208736],
            [-75.6150152297314, 45.247114117475505],
            [-75.614373535520945, 45.2463316135319]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI5',
      lat: 45.2469749673147, long: -75.6140792369843,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61396047497749, 45.24650157115501],
            [-75.61355631956951, 45.246665854341494],
            [-75.61419801130148, 45.24744835971047],
            [-75.61460217110806, 45.24728407509861],
            [-75.61396047497749, 45.24650157115501]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI6',
      lat: 45.2471751389741, long: -75.6135696172714,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61345085484606, 45.246701742814395],
            [-75.61304669801393, 45.24686602600086],
            [-75.61368839200719, 45.24764853136982],
            [-75.61409255323798, 45.24748424675796],
            [-75.61345085484606, 45.246701742814395]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI7',
      lat: 45.2453584608957, long: -75.6161284446716,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61680454722176, 45.24529141531419],
            [-75.61658546137227, 45.24500130695814],
            [-75.6154523413839, 45.24542549775987],
            [-75.6156714299882, 45.24571560569704],
            [-75.61680454722176, 45.24529141531419]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI8',
      lat: 45.2459098911521, long: -75.6147336959839,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61540606981282, 45.245826273414075],
            [-75.61517273519678, 45.24554172511631],
            [-75.61406132097977, 45.24599350044947],
            [-75.61429465862034, 45.246278048272124],
            [-75.61540606981282, 45.245826273414075]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI9',
      lat: 45.2464197705301, long: -75.613489151001,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61416153086509, 45.24633615279206],
            [-75.61392819415465, 45.24605160449429],
            [-75.61281676996168, 45.24650337982736],
            [-75.6130501096967, 45.24678792765],
            [-75.61416153086509, 45.24633615279206]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI10',
      lat: 45.2449958737006, long: -75.6158602237701,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61653632200478, 45.24492882811912],
            [-75.61631723755363, 45.244638719763095],
            [-75.61518412479762, 45.2450629105649],
            [-75.61540321200357, 45.24535301850209],
            [-75.61653632200478, 45.24492882811912]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI11',
      lat: 45.2455548613268, long: -75.6144225597382,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61509492936494, 45.245471243588796],
            [-75.61486159620716, 45.245186695291046],
            [-75.61375018893631, 45.24563847062427],
            [-75.61398352511856, 45.24592301844693],
            [-75.61509492936494, 45.245471243588796]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI12',
      lat: 45.2446861619721, long: -75.6156241893768,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61630028392557, 45.24461911639064],
            [-75.61608120066882, 45.244329008034605],
            [-75.61494809409044, 45.244753198836456],
            [-75.61516718010193, 45.24504330677364],
            [-75.61630028392557, 45.24461911639064]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI13',
      lat: 45.2452338218084, long: -75.6141436100006,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61481597582753, 45.24515020407041],
            [-75.61458264398834, 45.24486565577266],
            [-75.61347124299851, 45.24531743110594],
            [-75.61370457786205, 45.2456019789286],
            [-75.61481597582753, 45.24515020407041]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI14',
      lat: 45.2437947870867, long: -75.6153827905655,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.6156161180063, 45.243343006126466],
            [-75.61514946683565, 45.24334300517633],
            [-75.61514946683565, 45.24424656662169],
            [-75.61561612542835, 45.244246565671524],
            [-75.6156161180063, 45.243343006126466]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI15',
      lat: 45.2438929900901, long: -75.6149053573608,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61513868520495, 45.24344120912987],
            [-75.61467203322763, 45.24344120817974],
            [-75.61467203322763, 45.244344769625116],
            [-75.61513869262706, 45.24434476867496],
            [-75.61513868520495, 45.24344120912987]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI16',
      lat: 45.2441007266534, long: -75.6143206357956,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61455396449298, 45.243648945693174],
            [-75.61408731080934, 45.24364894474303],
            [-75.61408731080934, 45.244552506188406],
            [-75.61455397191526, 45.24455250523823],
            [-75.61455396449298, 45.243648945693174]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI17',
      lat: 45.2442971314328, long: -75.6138271093369,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61406043884097, 45.24384535047257],
            [-75.61359378354399, 45.24384534952242],
            [-75.61359378354399, 45.244748910967786],
            [-75.61406044626324, 45.24474891001759],
            [-75.61406043884097, 45.24384535047257]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI18',
      lat: 45.2448674568474, long: -75.6124377250671,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61311008655775, 45.244783839109445],
            [-75.61287675622339, 45.24449929081169],
            [-75.61176536240123, 45.24495106614505],
            [-75.61199869575995, 45.245235613967715],
            [-75.61311008655775, 45.244783839109445]
          ]]
        }
      }.to_json
    )

    tournament.fields.create!(
      name: 'UPI19',
      lat: 45.2444973125285, long: -75.6122714281082,
      geo_json: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'Polygon',
          coordinates: [[
            [-75.61294378521814, 45.24441369479057],
            [-75.61271045640405, 45.24412914649282],
            [-75.61159906982328, 45.24458092182624],
            [-75.61183240166167, 45.2448654696489],
            [-75.61294378521814, 45.24441369479057]
          ]]
        }
      }.to_json
    )
  end
end
