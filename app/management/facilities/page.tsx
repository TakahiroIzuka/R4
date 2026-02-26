import { createClient } from '@/lib/supabase/server'
import FacilitiesList from '@/components/management/FacilitiesList'

export default async function FacilitiesPage() {
  const supabase = await createClient()

  // Get current logged-in user
  const { data: { user: authUser } } = await supabase.auth.getUser()

  // Fetch current user's data from users table
  const { data: currentUser } = await supabase
    .from('users')
    .select('*')
    .eq('auth_user_id', authUser?.id)
    .single()

  const [
    { data: services },
    { data: facilities, error }
  ] = await Promise.all([
    supabase.from('services').select('*').order('id'),
    supabase
      .from('facilities')
      .select(`
        *,
        service:services(name),
        prefecture:prefectures(name),
        area:areas(name),
        facility_genres(genre:genres(name)),
        detail:facility_details!facility_id(name)
      `)
      .order('id', { ascending: false })
  ])

  if (error) {
    console.error('Error fetching facilities:', error)
  }

  // Transform facility_genres array to genre object
  const transformedFacilities = facilities?.map(facility => {
    const facilityGenres = facility.facility_genres as Array<{ genre: { id: number; name: string } }> | undefined
    const firstGenre = facilityGenres?.[0]?.genre
    return {
      ...facility,
      genre_id: firstGenre?.id,
      genre: firstGenre
    }
  }) || []

  return (
    <div>
      <div className="mb-6">
        <h1 className="text-2xl font-semibold text-gray-900">施設一覧</h1>
      </div>

      <FacilitiesList
        services={services || []}
        facilities={transformedFacilities}
        currentUserType={currentUser?.type || 'user'}
        currentUserCompanyId={currentUser?.company_id || null}
        showNewButton={currentUser?.type === 'admin'}
      />
    </div>
  )
}
