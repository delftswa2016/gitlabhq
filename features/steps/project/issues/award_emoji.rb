class Spinach::Features::AwardEmoji < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedProject
  include SharedPaths
  include Select2Helper

  step 'I visit "Bugfix" issue page' do
    visit namespace_project_issue_path(@project.namespace, @project, @issue)
  end

  step 'I click the thumbsup award Emoji' do
    page.within '.awards' do
      thumbsup = page.find('.award .emoji-1F44D')
      thumbsup.click
      thumbsup.hover
      sleep 0.3
    end
  end

  step 'I click to emoji-picker' do
    page.within '.awards-controls' do
      page.find('.add-award').click
    end
  end

  step 'I click to emoji in the picker' do
    page.within '.emoji-menu-content' do
      page.first('.emoji-icon').click
    end
  end

  step 'I can remove it by clicking to icon' do
    page.within '.awards' do
      expect do
        page.find('.award.active').click
        sleep 0.3
      end.to change{ page.all(".award").size }.from(3).to(2)
    end
  end

  step 'I can see the activity and food categories' do
    page.within '.emoji-menu' do
      expect(page).to_not have_selector 'Activity'
      expect(page).to_not have_selector 'Food'
    end
  end

  step 'I have award added' do
    sleep 0.2

    page.within '.awards' do
      expect(page).to have_selector '.award'
      expect(page.find('.award.active .counter')).to have_content '1'
      expect(page.find('.award.active')['data-original-title']).to eq('me')
    end
  end

  step 'I have no awards added' do
    page.within '.awards' do
      expect(page).to have_selector '.award'
      expect(page.all('.award').size).to eq(2)

      # Check tooltip data
      page.all('.award').each do |element|
        expect(element['title']).to eq("")
      end

      page.all('.award .counter').each do |element|
        expect(element).to have_content '0'
      end
    end
  end

  step 'project "Shop" has issue "Bugfix"' do
    @project = Project.find_by(name: 'Shop')
    @issue = create(:issue, title: 'Bugfix', project: project)
  end

  step 'I leave comment with a single emoji' do
    page.within('.js-main-target-form') do
      fill_in 'note[note]', with: ':smile:'
      click_button 'Add Comment'
    end
  end

  step 'I search "hand"' do
    page.within('.emoji-menu-content') do
      fill_in 'emoji_search', with: 'hand'
    end
  end

  step 'I see search result for "hand"' do
    page.within '.emoji-menu-content' do
      expect(page).to have_selector '[data-emoji="raised_hand"]'
    end
  end

  step 'The search field is focused' do
    expect(page).to have_selector('#emoji_search')
    expect(page.evaluate_script('document.activeElement.id')).to eq('emoji_search')
  end
end
