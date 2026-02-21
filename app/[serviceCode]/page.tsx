import ErrorMessage from '@/components/ErrorMessage'
import HomeClient from '@/components/HomeClient'
import { fetchAllFacilities, fetchFacilitiesImages } from '@/lib/data/facilities'

interface PageProps {
  params: Promise<{
    serviceCode: string
  }>
}

export default async function Page({ params }: PageProps) {
  const { serviceCode } = await params
  const { facilities, error } = await fetchAllFacilities(serviceCode)

  if (error) {
    return <ErrorMessage message={error.message} />
  }

  // Fetch images for all facilities
  const facilityIds = facilities?.map(f => f.id) || []
  const { imagesMap } = await fetchFacilitiesImages(facilityIds)

  return <HomeClient facilities={facilities || []} imagesMap={imagesMap} />
}
